import json
import os
import re
import sys
from pathlib import Path

import yaml

SDK_CONSTRAINT_RE = re.compile(r"^[ \t]*(\^|>=|>)?[ \t]*([0-9]+\.[0-9]+)\.[0-9]+.*$")


def get_language_version(pubspec: dict) -> str | None:
    env = pubspec.get("environment") or {}
    sdk_constraint = str(env.get("sdk", "")).strip()
    if not sdk_constraint:
        return "2.7"
    m = SDK_CONSTRAINT_RE.match(sdk_constraint)
    if m:
        return m.group(2)
    if sdk_constraint == "any":
        return None
    return "2.7"


def main() -> None:
    pub_deps_file = os.environ.get("pubDeps")
    if not pub_deps_file:
        sys.exit("Error: Missing pubDeps environment variable.")
    with Path(pub_deps_file).open("r", encoding="utf-8") as f:
        pub_deps = json.load(f)
    packages = {}
    for name, details in pub_deps.items():
        src = details.get("src")
        package_root = details.get("packageRoot", ".")
        base_path = Path(src) / package_root
        pubspec_path = base_path / "pubspec.yaml"
        if not pubspec_path.exists():
            sys.exit(
                f"Error: pubspec.yaml not found for package '{name}' at {pubspec_path}"
            )
        with pubspec_path.open("r", encoding="utf-8") as f:
            pubspec = yaml.load(f, Loader=yaml.CSafeLoader)
        packages[name] = {
            "name": name,
            "rootUri": base_path.resolve().as_uri(),
            "packageUri": "lib/",
            "languageVersion": get_language_version(pubspec),
        }
    main_pubspec_path = Path("pubspec.yaml")
    if not main_pubspec_path.exists():
        sys.exit("Error: Main pubspec.yaml not found.")
    with main_pubspec_path.open("r", encoding="utf-8") as f:
        main_pubspec = yaml.load(f, Loader=yaml.CSafeLoader)
    for package_path in main_pubspec.get("workspace", []):
        ws_pubspec_path = Path(package_path) / "pubspec.yaml"
        if not ws_pubspec_path.exists():
            sys.exit(f"Error: pubspec.yaml not found at {pubspec_path}")
        with ws_pubspec_path.open("r", encoding="utf-8") as f:
            ws_pubspec = yaml.load(f, Loader=yaml.CSafeLoader)
        ws_name = ws_pubspec.get("name")
        if ws_name and ws_name not in packages:
            packages[ws_name] = {
                "name": ws_name,
                "rootUri": Path(package_path).resolve().as_uri(),
                "packageUri": "lib/",
                "languageVersion": get_language_version(ws_pubspec),
            }
    main_name = main_pubspec.get("name")
    if main_name and main_name not in packages:
        packages[main_name] = {
            "name": main_name,
            "rootUri": "../",
            "packageUri": "lib/",
            "languageVersion": get_language_version(main_pubspec),
        }
    package_config = {
        "configVersion": 2,
        "generator": "nixpkgs",
        "packages": list(packages.values()),
    }
    out_dir = Path(".dart_tool")
    out_dir.mkdir(parents=True, exist_ok=True)
    with (out_dir / "package_config.json").open("w", encoding="utf-8") as f:
        json.dump(package_config, f, sort_keys=True, indent=4)


if __name__ == "__main__":
    main()
