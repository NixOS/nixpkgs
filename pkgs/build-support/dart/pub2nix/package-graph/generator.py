import json
import os
from pathlib import Path

import yaml


def main() -> None:
    attrs_file_path = Path(os.environ["NIX_ATTRS_JSON_FILE"])
    with attrs_file_path.open("r", encoding="utf-8") as f:
        attrs = json.load(f)
    package_graphs = []
    for name, data in attrs.get("packages", {}).items():
        with (
            Path(data["src"])
            / data.get("packageRoot", ".").lstrip("/")
            / "pubspec.yaml"
        ).open("r", encoding="utf-8") as f:
            pubspec = yaml.safe_load(f)
            package_graphs.append({
                "name": name,
                "version": pubspec.get("version") or "0.0.0",
                "dependencies": list((pubspec.get("dependencies") or {}).keys()),
            })
    with Path(attrs.get("pubspecFile")).open("r", encoding="utf-8") as f:
        pubspec = yaml.safe_load(f)
        package_graphs.append({
            "name": pubspec.get("name"),
            "version": pubspec.get("version") or "0.0.0",
            "dependencies": list((pubspec.get("dependencies") or {}).keys()),
            "devDependencies": list((pubspec.get("dev_dependencies") or {}).keys()),
        })
    print(
        json.dumps(
            {
                "roots": [pubspec.get("name")],
                "packages": package_graphs,
                "configVersion": 1,
            },
            indent=2,
            ensure_ascii=False,
        )
    )


if __name__ == "__main__":
    main()
