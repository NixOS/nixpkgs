import json
import re
from pathlib import Path

import yaml


def main() -> None:
    with Path("pubspec.yaml").open("r", encoding="utf-8") as f:
        pubspec = yaml.load(f, Loader=yaml.CSafeLoader)
    if not pubspec.get("workspace"):
        return
    with Path(".dart_tool/package_config.json").open("r", encoding="utf-8") as f:
        package_config = json.load(f)
    for package_path in pubspec.get("workspace", []):
        with (Path(package_path) / "pubspec.yaml").open("r", encoding="utf-8") as f:
            package_pubspec = yaml.load(f, Loader=yaml.CSafeLoader)
        m = re.match(
            r"^[ \t]*(\^|>=|>)?[ \t]*([0-9]+\.[0-9]+)\.[0-9]+.*$",
            package_pubspec.get("environment", {}).get("sdk", ""),
        )
        if m:
            languageVersion = m.group(2)
        elif package_pubspec.get("environment", {}).get("sdk") == "any":
            languageVersion = "null"
        else:
            languageVersion = "2.7"
        if not any(
            pkg["name"] == package_pubspec["name"] for pkg in package_config["packages"]
        ):
            package_config["packages"].append({
                "name": package_pubspec["name"],
                "rootUri": Path(package_path).resolve().as_uri(),
                "packageUri": "lib/",
                "languageVersion": languageVersion,
            })
    with Path(".dart_tool/package_config.json").open("w", encoding="utf-8") as f:
        json.dump(package_config, f, sort_keys=True, indent=4)


if __name__ == "__main__":
    main()
