"""Test cache recovery and launcher behavior with a disposable fake app."""

import json
import os
import selectors
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

LAUNCHER = Path(sys.argv.pop(1)).resolve()


class LauncherTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="chatgpt-launcher-test-")
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.source = self.root / "resources"
        self.source.mkdir()
        empty_path = self.root / "empty-path"
        empty_path.mkdir()
        for resource in ["codex", "codex-code-mode-host", "rg"]:
            (self.source / resource).write_text("fixture")
        for resource in ["cua_node", "native", "tectonic"]:
            (self.source / resource).mkdir()
        self.manifest = Path("browser/.codex-plugin/plugin.json")
        self.service = Path("browser/scripts/browser service.mjs")
        for relative, content in [
            (self.manifest, '{"original": true}\n'),
            (self.service, "fixture\n"),
        ]:
            path = self.source / "plugins" / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content)
            path.chmod(0o444)
        app = self.root / "fake-app"
        app.write_text(
            f"#!{sys.executable}\n"
            + """
import json,os,sys
print(json.dumps({'args':sys.argv[1:],'resources':os.environ['CODEX_ELECTRON_BUNDLED_PLUGINS_RESOURCES_PATH']}),flush=True)
if os.environ.get('HOLD_APP'):
    sys.stdin.buffer.read(1)
"""
        )
        app.chmod(0o755)
        self.env = {
            **os.environ,
            "PATH": str(empty_path),
            "HOME": str(self.root / "home"),
            "XDG_CACHE_HOME": str(self.root / "cache"),
            "CHATGPT_EXECUTABLE": str(app),
            "CHATGPT_RESOURCES_SOURCE": str(self.source),
            "CHATGPT_RESOURCES_CACHE_KEY": "fixture-output",
            "NIXOS_OZONE_WL": "",
            "WAYLAND_DISPLAY": "",
        }
        self.cache = self.root / "cache/chatgpt/bundled-plugins-v2/fixture-output"

    def launch(self, *args):
        result = subprocess.run(
            [str(LAUNCHER), *args],
            env=self.env,
            capture_output=True,
            text=True,
            timeout=10,
            check=True,
        )
        return json.loads(result.stdout)

    def test_initialization_and_arguments(self):
        data = self.launch("--fixture", "argument with spaces")
        self.assertEqual(data["args"], ["--fixture", "argument with spaces"])
        self.assertEqual(data["resources"], str(self.cache))
        self.assertTrue((self.cache / ".complete").is_file())
        self.assertTrue((self.cache / "plugins" / self.service).stat().st_mode & 0o200)
        self.assertTrue((self.cache / "codex").samefile(self.source / "codex"))

    def test_deleted_file_repaired_without_overwriting_manifest(self):
        self.launch()
        manifest = self.cache / "plugins" / self.manifest
        manifest.write_text('{"modified": true}\n')
        (self.cache / "plugins" / self.service).unlink()
        self.launch()
        self.assertTrue((self.cache / "plugins" / self.service).is_file())
        self.assertEqual(manifest.read_text(), '{"modified": true}\n')

    def test_broken_helper_link_repaired(self):
        self.launch()
        (self.cache / "codex").unlink()
        (self.cache / "codex").symlink_to(self.root / "missing")
        self.launch()
        self.assertTrue((self.cache / "codex").samefile(self.source / "codex"))

    def test_partial_initialization_preserves_existing_manifest(self):
        manifest = self.cache / "plugins" / self.manifest
        manifest.parent.mkdir(parents=True)
        manifest.write_text('{"modified": true}\n')
        self.launch()
        self.assertEqual(manifest.read_text(), '{"modified": true}\n')
        self.assertTrue((self.cache / "plugins" / self.service).is_file())

    def test_wayland_requires_both_environment_variables(self):
        self.env["NIXOS_OZONE_WL"] = "1"
        self.assertEqual(self.launch()["args"], [])
        self.env["WAYLAND_DISPLAY"] = "wayland-fixture"
        self.assertIn("--ozone-platform=wayland", self.launch()["args"])

    def test_concurrent_initialization(self):
        commands = [
            subprocess.Popen(
                [str(LAUNCHER)],
                env=self.env,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
            )
            for _ in range(2)
        ]
        try:
            for command in commands:
                stdout, stderr = command.communicate(timeout=10)
                self.assertEqual(command.returncode, 0, stderr)
                self.assertEqual(json.loads(stdout)["resources"], str(self.cache))
            self.assertTrue((self.cache / "plugins" / self.service).is_file())
        finally:
            for command in commands:
                if command.poll() is None:
                    command.kill()
                command.wait()

    def wait_for_app(self, command):
        # A failed or deadlocked launcher must not leave this test blocked on read.
        with selectors.DefaultSelector() as selector:
            selector.register(command.stdout, selectors.EVENT_READ)
            self.assertTrue(
                selector.select(timeout=10), "launcher did not start the app"
            )
        self.assertEqual(
            json.loads(command.stdout.readline())["resources"], str(self.cache)
        )

    def test_runtime_aliases_and_user_additions_survive_repair(self):
        self.launch()
        addition = self.cache / "plugins/local-addition"
        addition.write_text("keep this file")
        alias = self.cache / "plugins/latest"
        alias.symlink_to("browser")
        (self.cache / "plugins" / self.service).unlink()
        self.launch()
        self.assertEqual(addition.read_text(), "keep this file")
        self.assertEqual(os.readlink(alias), "browser")

    def test_repair_refuses_active_cache_then_succeeds_after_exit(self):
        command = subprocess.Popen(
            [str(LAUNCHER)],
            env={**self.env, "HOLD_APP": "1"},
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        try:
            self.wait_for_app(command)
            missing = self.cache / "plugins" / self.service
            missing.unlink()
            manifest = self.cache / "plugins" / self.manifest
            manifest.write_text('{"modified": true}\n')
            result = subprocess.run(
                [str(LAUNCHER)],
                env=self.env,
                capture_output=True,
                text=True,
                timeout=10,
                check=False,
            )
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("cache needs repair but is in use", result.stderr)
            self.assertFalse(missing.exists())
            self.assertTrue((self.cache / ".complete").is_file())
            self.assertEqual(manifest.read_text(), '{"modified": true}\n')
            command.communicate(input="x", timeout=10)
            self.assertEqual(command.returncode, 0)
            self.launch()
            self.assertTrue(missing.is_file())
            self.assertEqual(manifest.read_text(), '{"modified": true}\n')
        finally:
            if command.poll() is None:
                command.kill()
            command.wait()

    def test_running_application_holds_cleanup_lock(self):
        command = subprocess.Popen(
            [str(LAUNCHER)],
            env={**self.env, "HOLD_APP": "1"},
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        try:
            self.wait_for_app(command)
            result = subprocess.run(
                ["flock", "--exclusive", "--nonblock", str(self.cache), "true"],
                timeout=10,
                check=False,
            )
            self.assertEqual(result.returncode, 1)
            command.communicate(input="x", timeout=10)
            self.assertEqual(command.returncode, 0)
        finally:
            if command.poll() is None:
                command.kill()
            command.wait()


if __name__ == "__main__":
    unittest.main()
