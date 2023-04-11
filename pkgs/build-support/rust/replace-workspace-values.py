# This script implements the workspace inheritance mechanism described
# here: https://doc.rust-lang.org/cargo/reference/workspaces.html#the-package-table
#
# Please run `mypy --strict`, `black`, and `isort --profile black` on this after editing, thanks!

import sys
from typing import Any

import tomli
import tomli_w


def load_file(path: str) -> dict[str, Any]:
    with open(path, "rb") as f:
        return tomli.load(f)


def replace_key(
    workspace_manifest: dict[str, Any], table: dict[str, Any], section: str, key: str
) -> bool:
    if "workspace" in table[key] and table[key]["workspace"] is True:
        print("replacing " + key)

        replaced = table[key]
        del replaced["workspace"]

        workspace_copy = workspace_manifest[section][key]

        if section == "dependencies":
            crate_features = replaced.get("features")

            if type(workspace_copy) is str:
                replaced["version"] = workspace_copy
            else:
                replaced.update(workspace_copy)

                merged_features = (crate_features or []) + (
                    workspace_copy.get("features") or []
                )

                if len(merged_features) > 0:
                    # Dictionaries are guaranteed to be ordered (https://stackoverflow.com/a/7961425)
                    replaced["features"] = list(dict.fromkeys(merged_features))
        elif section == "package":
            table[key] = replaced = workspace_copy

        return True

    return False


def replace_dependencies(
    workspace_manifest: dict[str, Any], root: dict[str, Any]
) -> bool:
    changed = False

    for key in ["dependencies", "dev-dependencies", "build-dependencies"]:
        if key in root:
            for k in root[key].keys():
                changed |= replace_key(workspace_manifest, root[key], "dependencies", k)

    return changed


def main() -> None:
    crate_manifest = load_file(sys.argv[1])
    workspace_manifest = load_file(sys.argv[2])["workspace"]

    if "workspace" in crate_manifest:
        return

    changed = False

    for key in crate_manifest["package"].keys():
        changed |= replace_key(
            workspace_manifest, crate_manifest["package"], "package", key
        )

    changed |= replace_dependencies(workspace_manifest, crate_manifest)

    if "target" in crate_manifest:
        for key in crate_manifest["target"].keys():
            changed |= replace_dependencies(
                workspace_manifest, crate_manifest["target"][key]
            )

    if not changed:
        return

    with open(sys.argv[1], "wb") as f:
        tomli_w.dump(crate_manifest, f)


if __name__ == "__main__":
    main()
