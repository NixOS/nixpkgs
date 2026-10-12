"""Exercise release selection and publication without network access."""

import base64
import gzip
import hashlib
import io
import json
import os
import shutil
import subprocess
import sys
import tarfile
import tempfile
import unittest
from pathlib import Path

UPDATE_SCRIPT = Path(sys.argv.pop(1)).resolve()
BASE_URL = "https://persistent.oaistatic.com/codex-app-prod"
VERSION = "26.1007.21434"


def digest(data):
    return "sha256-" + base64.b64encode(hashlib.sha256(data).digest()).decode()


def debian_archive(architecture, version=VERSION, package="chatgpt"):
    control = f"Package: {package}\nVersion: {version}\nArchitecture: {architecture}\nMaintainer: Fixture\nDescription: Fixture\n".encode()
    stream = io.BytesIO()
    with tarfile.open(fileobj=stream, mode="w:gz") as archive:
        member = tarfile.TarInfo("./control")
        member.size = len(control)
        archive.addfile(member, io.BytesIO(control))
    result = b"!<arch>\n"
    for name, data in [
        ("debian-binary", b"2.0\n"),
        ("control.tar.gz", stream.getvalue()),
        ("data.tar.gz", gzip.compress(b"")),
    ]:
        header = f"{name + '/':<16}{0:<12}{0:<6}{0:<6}{'100644':<8}{len(data):<10}`\n".encode()
        result += header + data + (b"\n" if len(data) % 2 else b"")
    return result


class UpdateTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="chatgpt-update-test-")
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.bin = self.root / "bin"
        self.bin.mkdir()
        self.source = self.root / "source.json"
        self.source.write_text('{"original": true}\n')
        self.mapping = {}
        self.metadata = {}
        for architecture in ["amd64", "arm64"]:
            self.set_linux_artifact(architecture, debian_archive(architecture))
        darwin = self.root / "darwin.zip"
        darwin.write_bytes(b"darwin fixture")
        self.darwin_url = f"{BASE_URL}/ChatGPT-darwin-arm64-{VERSION}.zip"
        self.mapping[self.darwin_url] = str(darwin)
        self.jq = shutil.which("jq")
        self.write_stub(
            "curl",
            """
import json,os,sys
from pathlib import Path
mapping=json.loads(Path(os.environ['FIXTURE_MAPPING']).read_text())
url=sys.argv[-1]
sys.stdout.buffer.write(Path(mapping[url]).read_bytes())
""",
        )
        self.write_stub(
            "nix-prefetch-url",
            """
import hashlib,json,os,sys
from pathlib import Path
mapping=json.loads(Path(os.environ['FIXTURE_MAPPING']).read_text())
url=sys.argv[-1]
path=Path(mapping[url])
with open(os.environ['PREFETCH_LOG'],'a') as log: log.write(url+'\\n')
print(hashlib.sha256(path.read_bytes()).hexdigest())
if '--print-path' in sys.argv: print(path)
""",
        )

    def write_stub(self, name, text):
        path = self.bin / name
        path.write_text(f"#!{sys.executable}\n" + text)
        path.chmod(0o755)

    def set_linux_artifact(self, architecture, data):
        artifact = self.root / f"{architecture}.deb"
        artifact.write_bytes(data)
        filename = f"pool/main/c/chatgpt/chatgpt_{VERSION}_{architecture}.deb"
        self.mapping[f"{BASE_URL}/linux/deb/{filename}"] = str(artifact)
        self.metadata[architecture] = {
            "Package": "chatgpt",
            "Version": VERSION,
            "Architecture": architecture,
            "Filename": filename,
            "Size": str(len(data)),
            "SHA256": hashlib.sha256(data).hexdigest(),
        }

    def run_update(self, success=True, darwin_url=None):
        appcast = self.root / "appcast.xml"
        size = (self.root / "darwin.zip").stat().st_size
        appcast.write_text(
            f'<rss xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle"><channel><item><sparkle:shortVersionString>{VERSION}</sparkle:shortVersionString><enclosure url="{darwin_url or self.darwin_url}" length="{size}"/></item></channel></rss>'
        )
        self.mapping[f"{BASE_URL}/appcast.xml"] = str(appcast)
        for architecture, fields in self.metadata.items():
            index = self.root / f"{architecture}.gz"
            index.write_bytes(
                gzip.compress(
                    "".join(
                        f"{key}: {value}\n" for key, value in fields.items()
                    ).encode()
                )
            )
            self.mapping[
                f"{BASE_URL}/linux/deb/dists/stable/main/binary-{architecture}/Packages.gz"
            ] = str(index)
        mapping_path = self.root / "mapping.json"
        mapping_path.write_text(json.dumps(self.mapping))
        environment = {
            **os.environ,
            "PATH": f"{self.bin}:{os.environ['PATH']}",
            "SOURCE_JSON": str(self.source),
            "FIXTURE_MAPPING": str(mapping_path),
            "PREFETCH_LOG": str(self.root / "prefetch.log"),
        }
        result = subprocess.run(
            ["bash", str(UPDATE_SCRIPT)],
            env=environment,
            capture_output=True,
            text=True,
            timeout=20,
            check=False,
        )
        if success:
            self.assertEqual(result.returncode, 0, result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertEqual(self.source.read_text(), '{"original": true}\n')
        self.assertEqual(list(self.root.glob(".chatgpt-source.*")), [])
        return result

    def test_valid_update(self):
        self.run_update()
        data = json.loads(self.source.read_text())
        for architecture, system in [
            ("amd64", "x86_64-linux"),
            ("arm64", "aarch64-linux"),
        ]:
            self.assertEqual(
                data[system]["src"]["hash"],
                digest((self.root / f"{architecture}.deb").read_bytes()),
            )
        self.assertEqual(set(data), {"aarch64-darwin", "aarch64-linux", "x86_64-linux"})

    def test_unchanged_skips_artifact_downloads(self):
        self.run_update()
        (self.root / "prefetch.log").unlink()
        self.run_update()
        self.assertFalse((self.root / "prefetch.log").exists())

    def test_wrong_digest_preserves_source(self):
        self.metadata["amd64"]["SHA256"] = "0" * 64
        self.run_update(success=False)

    def test_wrong_size_preserves_source(self):
        self.metadata["arm64"]["Size"] = "1"
        self.run_update(success=False)

    def test_wrong_control_architecture(self):
        self.set_linux_artifact("amd64", debian_archive("arm64"))
        self.run_update(success=False)

    def test_wrong_control_version(self):
        self.set_linux_artifact("amd64", debian_archive("amd64", version="1.0"))
        self.run_update(success=False)

    def test_wrong_control_package(self):
        self.set_linux_artifact("amd64", debian_archive("amd64", package="other"))
        self.run_update(success=False)

    def test_invalid_debian_archive(self):
        self.set_linux_artifact("amd64", b"invalid archive")
        self.run_update(success=False)

    def test_unexpected_linux_path(self):
        self.metadata["amd64"]["Filename"] = "../other.deb"
        self.run_update(success=False)
        self.assertFalse((self.root / "prefetch.log").exists())

    def test_unexpected_darwin_host(self):
        self.run_update(
            success=False,
            darwin_url=f"https://example.org/ChatGPT-darwin-arm64-{VERSION}.zip",
        )
        self.assertFalse((self.root / "prefetch.log").exists())

    def test_failed_json_generation_preserves_source(self):
        self.write_stub(
            "jq",
            f"""
import os,sys
if '-n' in sys.argv:
    print('{{')
    sys.exit(1)
os.execv({self.jq!r},[{self.jq!r},*sys.argv[1:]])
""",
        )
        self.run_update(success=False)


if __name__ == "__main__":
    unittest.main()
