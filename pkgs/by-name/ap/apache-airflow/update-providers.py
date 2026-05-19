#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages(ps: [ps.requests ps.tomli ps.packaging])"

from itertools import chain
import json
import logging
from pathlib import Path
import os
import re
import subprocess
import sys
from typing import Dict, List, Optional, Set, TextIO
from urllib.request import urlopen
from urllib.error import HTTPError
from packaging.requirements import Requirement
import tomli

PKG_SET = "apache-airflow.pythonPackages"

# If some requirements are matched by multiple or no Python packages, the
# following can be used to choose the correct one
PKG_PREFERENCES = {
    "dnspython": "dnspython",
    "elasticsearch-dsl": "elasticsearch-dsl",
    "google-api-python-client": "google-api-python-client",
    "numpy": "numpy",
    "protobuf": "protobuf",
    "pydantic": "pydantic",
    "requests_toolbelt": "requests-toolbelt",
}

# Requirements missing from the airflow provider metadata
EXTRA_REQS = {
    "sftp": ["pysftp"],
}


def get_version():
    with open(os.path.dirname(sys.argv[0]) + "/python-package.nix") as fh:
        # A version consists of digits, dots, and possibly a "b" (for beta)
        m = re.search(r'version = "([\d.b]+)";', fh.read())
        return m.group(1)


def get_file_from_github(version: str, path: str):
    with urlopen(
        f"https://raw.githubusercontent.com/apache/airflow/{version}/{path}"
    ) as response:
        return response.read()


def repository_root() -> Path:
    return Path(os.path.dirname(sys.argv[0])) / "../../../../"


def dump_packages() -> Dict[str, Dict[str, str]]:
    # Store a JSON dump of Nixpkgs' python3Packages
    output = subprocess.check_output(
        [
            "nix-env",
            "-f",
            repository_root(),
            "-qa",
            "-A",
            PKG_SET,
            "--arg",
            "config",
            "{ allowAliases = false; }",
            "--json",
        ]
    )
    return json.loads(output)


def remove_version_constraint(req: str) -> str:
    parsed_req = Requirement(req)
    name = parsed_req.name
    extras = ",".join(sorted(parsed_req.extras))
    if extras:
        return f"{name}[{extras}]"
    return name


def name_to_attr_path(req: str, packages: Dict[str, Dict[str, str]]) -> Optional[str]:
    # Extract the base name, removing any extras (e.g., '[flask]')
    base_req_name = req.split("[")[0]
    logging.debug(f"Searching for base_req_name: {base_req_name}")
    if base_req_name in PKG_PREFERENCES:
        return f"{PKG_SET}.{PKG_PREFERENCES[base_req_name]}"
    attr_paths = []
    names = [base_req_name]
    # E.g. python-mpd2 is actually called python3.6-mpd2
    # instead of python-3.6-python-mpd2 inside Nixpkgs
    if base_req_name.startswith("python-") or base_req_name.startswith("python_"):
        names.append(base_req_name[len("python-") :])
    for name in names:
        # treat "-" and "_" equally
        name = re.sub("[-_]", "[-_]", name)
        # python(minor).(major)-(pname)-(version or unstable-date)
        # we need the version qualifier, or we'll have multiple matches
        # (e.g. pyserial and pyserial-asyncio when looking for pyserial)
        pattern = re.compile(rf"^python\d+\.\d+-{name}-(?:[\d\.]+|unstable-.*)", re.I)
        for attr_path, package in packages.items():
            # logging.debug("Checking match for %s with %s", name, package["name"])
            if pattern.match(package["name"]):
                attr_paths.append(attr_path)
    # Let's hope there's only one derivation with a matching name
    assert len(attr_paths) <= 1, f"{req} matches more than one derivation: {attr_paths}"
    if attr_paths:
        return attr_paths[0]
    return None


def provider_reqs_to_attr_paths(reqs: List, packages: Dict) -> List:
    no_version_reqs = map(remove_version_constraint, reqs)
    filtered_reqs = [
        req for req in no_version_reqs if not re.match(r"^apache-airflow", req)
    ]
    attr_paths = []
    for req in filtered_reqs:
        attr_path = name_to_attr_path(req, packages)
        if attr_path is not None:
            # Add attribute path without "python3Packages." prefix
            pname = attr_path[len(PKG_SET + ".") :]
            attr_paths.append(pname)
        else:
            # If we can't find it, we just skip and warn the user
            logging.warning("Could not find package attr for %s", req)
    return attr_paths


def get_cross_provider_reqs(
    provider: str, provider_reqs: Dict, cross_provider_deps: Dict, seen: List = None
) -> Set:
    # Unfortunately there are circular cross-provider dependencies, so keep a
    # list of ones we've seen already
    seen = seen or []
    reqs = set(provider_reqs[provider])
    if len(cross_provider_deps[provider]) > 0:
        reqs.update(
            chain.from_iterable(
                (
                    get_cross_provider_reqs(
                        d, provider_reqs, cross_provider_deps, seen + [provider]
                    )
                    if d not in seen
                    else []
                )
                for d in cross_provider_deps[provider]
            )
        )
    return reqs


def parse_pyproject_toml(version: str, provider_name: str) -> Dict:
    provider_dir = provider_name.replace(".", "/")
    path = f"providers/{provider_dir}/pyproject.toml"
    try:
        content = get_file_from_github(version, path)
        data = tomli.loads(content.decode("utf-8"))

        dependencies = data.get("project", {}).get("dependencies", [])

        # Extract optional dependencies
        optional_dependencies = data.get("project", {}).get("optional-dependencies", {})
        for opt_deps_list in optional_dependencies.values():
            dependencies.extend(opt_deps_list)

        imports = []
        # Heuristic to generate imports based on provider name
        # This might not be exhaustive but covers common cases
        base_import_path = f"airflow.providers.{provider_name.replace('-', '.')}"
        imports.append(base_import_path)

        # Try to get more specific imports from provider_info entry point if available
        provider_info_entry_point = (
            data.get("project", {})
            .get("entry-points", {})
            .get("apache_airflow_provider", {})
            .get("provider_info")
        )
        if provider_info_entry_point:
            module_path = provider_info_entry_point.split(":")[0]
            if module_path not in imports:
                imports.append(module_path)

        return {
            "deps": dependencies,
            "imports": sorted(list(set(imports))),  # Remove duplicates and sort
            "cross-providers-deps": [],  # pyproject.toml doesn't directly list cross-provider deps
            "version": data.get("project", {}).get("version", "unknown"),
        }
    except HTTPError:
        logging.warning("Couldn't get pyproject.toml for %s", provider_name)
        return {"deps": [], "imports": [], "cross-providers-deps": []}
    except Exception as e:
        logging.error(f"Error parsing pyproject.toml for {provider_name}: {e}")
        return {"deps": [], "imports": [], "cross-providers-deps": []}


def get_provider_reqs(version: str, packages: Dict, provider_names: List[str]) -> Dict:
    provider_data = {}
    for provider in provider_names:
        data = parse_pyproject_toml(version, provider)
        provider_data[provider] = {
            "deps": data["deps"],
            "cross-providers-deps": data["cross-providers-deps"],
        }

    provider_reqs = {}
    cross_provider_deps = {}
    for provider, data in provider_data.items():
        provider_reqs[provider] = list(
            provider_reqs_to_attr_paths(data["deps"], packages)
        ) + EXTRA_REQS.get(provider, [])
        cross_provider_deps[provider] = data["cross-providers-deps"]

    transitive_provider_reqs = {}
    # Add transitive cross-provider reqs
    for provider in provider_reqs:
        transitive_provider_reqs[provider] = get_cross_provider_reqs(
            provider, provider_reqs, cross_provider_deps
        )
    return transitive_provider_reqs


def get_provider_imports(version: str, provider_names: List[str]) -> Dict:
    provider_imports = {}
    for provider in provider_names:
        data = parse_pyproject_toml(version, provider)
        provider_imports[provider] = data["imports"]
    return provider_imports


def get_provider_versions(version: str, provider_names: List[str]) -> Dict:
    provider_versions = {}
    for provider in provider_names:
        data = parse_pyproject_toml(version, provider)
        provider_versions[provider] = data["version"]
    return provider_versions


def to_nix_expr(
    provider_reqs: Dict, provider_imports: Dict, provider_versions: Dict, fh: TextIO
) -> None:
    fh.write("# Warning: generated by update-providers.py, do not update manually\n")
    fh.write("{\n")
    for provider, reqs in provider_reqs.items():
        provider_name = provider.replace(".", "_")
        fh.write(f"  {provider_name} = {{\n")
        fh.write(
            "    deps = [ " + " ".join(sorted(f'"{req}"' for req in reqs)) + " ];\n"
        )
        fh.write(
            "    imports = [ "
            + " ".join(sorted(f'"{imp}"' for imp in provider_imports[provider]))
            + " ];\n"
        )
        fh.write(f'    version = "{provider_versions[provider]}";\n')
        fh.write("  };\n")
        fh.write("\n")
    fh.write("}\n")


def get_all_providers_from_github(version: str) -> List[str]:
    """
    Fetches all provider paths that contain a pyproject.toml file from the airflow repository.
    This is done by recursively fetching the git tree for the providers directory.
    """
    providers = []
    try:
        # Get the SHA of the 'providers' directory for the given version
        with urlopen(
            f"https://api.github.com/repos/apache/airflow/contents/?ref={version}"
        ) as response:
            root_contents = json.loads(response.read())

        providers_dir_info = next(
            (
                item
                for item in root_contents
                if item["name"] == "providers" and item["type"] == "dir"
            ),
            None,
        )

        if not providers_dir_info:
            logging.error(
                "Could not find 'providers' directory in the root of the repository."
            )
            sys.exit(1)

        providers_dir_sha = providers_dir_info["sha"]

        # Now, get the tree for the 'providers' directory recursively
        with urlopen(
            f"https://api.github.com/repos/apache/airflow/git/trees/{providers_dir_sha}?recursive=1"
        ) as response:
            tree = json.loads(response.read())

        pyproject_paths = [
            item["path"]
            for item in tree["tree"]
            if item["type"] == "blob" and item["path"].endswith("/pyproject.toml")
        ]

        for path in pyproject_paths:
            # remove /pyproject.toml suffix
            provider_path = path[: -len("/pyproject.toml")]
            # Exclude tests directory and empty paths (root pyproject.toml)
            if provider_path and not provider_path.startswith("tests/"):
                provider_name = provider_path.replace("/", ".")
                providers.append(provider_name)

    except HTTPError as e:
        logging.error(f"Error fetching provider list from GitHub: {e}")
        sys.exit(1)

    return sorted(providers)


def main() -> None:
    logging.basicConfig(level=logging.DEBUG)
    version = get_version()
    packages = dump_packages()
    logging.info("Generating providers.nix for version %s", version)

    # Fetch provider names from GitHub API
    provider_names = get_all_providers_from_github(version)

    provider_reqs = get_provider_reqs(version, packages, provider_names)
    provider_imports = get_provider_imports(version, provider_names)
    provider_versions = get_provider_versions(version, provider_names)
    with open(os.path.join(os.path.dirname(sys.argv[0]), "providers.nix"), "w") as fh:
        to_nix_expr(provider_reqs, provider_imports, provider_versions, fh)


if __name__ == "__main__":
    main()
