import json
import re
import sys
from pathlib import Path

MARKER = b"\n// denoCacheMetadata="
KEPT_HEADERS = {"content-type", "location", "x-typescript-types", "x-deno-warning"}
JSR_PACKAGE_META = re.compile(r"^https://jsr\.io/(@[^/]+/[^/]+)/meta\.json$")
LOCK_KEY = re.compile(r"^(@?[^@]+)@([^_]+)")


def locked_versions(entries):
    versions = {}
    for key in entries:
        match = LOCK_KEY.match(key)
        if match:
            versions.setdefault(match[1], set()).add(match[2])
    return versions


def semver_key(version):
    core, _, prerelease = version.partition("-")
    return [int(part) for part in core.split(".")], prerelease == "", prerelease


def dump(value):
    return json.dumps(value, sort_keys=True, separators=(",", ":")).encode()


def normalize_remote(path, jsr):
    data = path.read_bytes()
    split = data.rfind(MARKER)
    if split < 0:
        return
    content, metadata = data[:split], json.loads(data[split + len(MARKER) :])
    metadata["headers"] = {
        name: value
        for name, value in metadata.get("headers", {}).items()
        if name in KEPT_HEADERS
    }
    metadata["time"] = 0
    package = JSR_PACKAGE_META.match(metadata.get("url", ""))
    if package:
        meta = json.loads(content)
        kept = sorted(jsr.get(package[1], set()) & meta["versions"].keys(), key=semver_key)
        meta = {key: meta[key] for key in ("scope", "name") if key in meta}
        meta["versions"] = {version: {} for version in kept}
        if kept:
            meta["latest"] = kept[-1]
        content = dump(meta)
    path.write_bytes(content + MARKER + dump(metadata))


def normalize_packument(path, npm):
    packument = json.loads(path.read_text())
    kept = npm.get(packument["name"], set())
    packument["versions"] = {
        version: {key: value for key, value in manifest.items() if key != "deprecated"}
        for version, manifest in packument["versions"].items()
        if version in kept
    }
    packument["dist-tags"] = {}
    packument.pop("time", None)
    packument.pop("_deno.etag", None)
    path.write_bytes(dump(packument))


def main(cache, lockfile):
    cache, lock = Path(cache), json.loads(Path(lockfile).read_text())
    jsr, npm = locked_versions(lock.get("jsr", {})), locked_versions(lock.get("npm", {}))
    for path in cache.glob("*_analysis_cache_v2*"):
        path.unlink()
    for path in sorted((cache / "remote").rglob("*")):
        if path.is_file():
            normalize_remote(path, jsr)
    for path in sorted((cache / "npm").rglob("registry.json")):
        normalize_packument(path, npm)


if __name__ == "__main__":
    main(*sys.argv[1:])
