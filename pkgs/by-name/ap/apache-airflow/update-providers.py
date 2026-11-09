#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages(ps: [ps.packaging])"

from itertools import chain
import json
import logging
from pathlib import Path
import os
import re
import subprocess
import sys
from typing import Dict, List, Optional, Set, TextIO
from urllib.request import Request, urlopen
from urllib.error import HTTPError
from packaging.requirements import Requirement

try:
    import tomllib
except ImportError:
    import tomli as tomllib

PKG_SET = "apache-airflow.pythonPackages"

# Optional manual overrides when multiple packages match and cannot be resolved
# automatically, or when the attribute name deviates completely from the requirement name.
PKG_PREFERENCES: Dict[str, str] = {}

# Requirements missing from the airflow provider metadata
EXTRA_REQS = {
    "sftp": ["pysftp"],
}


def get_version() -> str:
    with open(os.path.dirname(sys.argv[0]) + "/python-package.nix") as fh:
        # A version consists of digits, dots, and possibly a "b" (for beta)
        m = re.search(r'version = "([\d.b]+)";', fh.read())
        return m.group(1)


def get_source_dir() -> Optional[Path]:
    try:
        out = subprocess.check_output(
            ["nix-build", str(repository_root()), "-A", "apache-airflow.src", "--no-out-link"],
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
        if out and os.path.isdir(out):
            return Path(out)
    except Exception as e:
        logging.debug("Could not build apache-airflow.src locally: %s", e)
    return None


def get_file_from_github(version: str, path: str) -> bytes:
    url = f"https://raw.githubusercontent.com/apache/airflow/{version}/{path}"
    req = Request(url)
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    with urlopen(req) as response:
        return response.read()


def repository_root() -> Path:
    return Path(os.path.dirname(sys.argv[0])) / "../../../../"


def dump_packages() -> Dict[str, Dict[str, str]]:
    # Store a JSON dump of Nixpkgs' python3Packages
    output = subprocess.check_output(
        [
            "nix-env",
            "-f",
            str(repository_root()),
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
    logging.debug("Searching for base_req_name: %s", base_req_name)
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
            if pattern.match(package["name"]):
                attr_paths.append(attr_path)
    # Let's hope there's only one derivation with a matching name
    attr_paths = list(dict.fromkeys(attr_paths))
    if len(attr_paths) == 1:
        return attr_paths[0]
    elif len(attr_paths) > 1:
        candidates = {ap[len(PKG_SET + ".") :]: ap for ap in attr_paths}
        norm_req = base_req_name.replace("_", "-").lower()

        # 1. Prefer exact attribute match (treating '-' and '_' as equal)
        exact_matches = [
            ap
            for attr, ap in candidates.items()
            if attr.replace("_", "-").lower() == norm_req
            or (
                base_req_name.startswith(("python-", "python_"))
                and attr.replace("_", "-").lower() == norm_req[len("python-") :]
            )
        ]
        if len(exact_matches) == 1:
            logging.debug(
                "Disambiguated %s from %s to exact match %s",
                base_req_name,
                list(candidates.keys()),
                exact_matches[0],
            )
            return exact_matches[0]

        # 2. Prefer the general suffixless version (i.e. attribute without version suffix like _1, _1_4, etc.)
        suffixless = [
            ap
            for attr, ap in candidates.items()
            if not re.search(r"[-_]v?\d+([-_]\d+)*$|\d+$", attr)
        ]
        if len(suffixless) == 1:
            logging.debug(
                "Disambiguated %s from %s to suffixless match %s",
                base_req_name,
                list(candidates.keys()),
                suffixless[0],
            )
            return suffixless[0]

        raise AssertionError(
            f"{req} matches multiple derivations and could not be resolved to a suffixless version: {list(candidates.keys())}"
        )
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


def parse_pyproject_toml(source_dir: Optional[Path], version: str, provider_name: str) -> Dict:
    provider_dir = provider_name.replace(".", "/")
    path = f"providers/{provider_dir}/pyproject.toml"
    try:
        if source_dir:
            with open(source_dir / path, "rb") as f:
                data = tomllib.load(f)
        else:
            content = get_file_from_github(version, path)
            data = tomllib.loads(content.decode("utf-8"))

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
        return {"deps": [], "imports": [], "cross-providers-deps": [], "version": "unknown"}
    except Exception as e:
        logging.error("Error parsing pyproject.toml for %s: %s", provider_name, e)
        return {"deps": [], "imports": [], "cross-providers-deps": [], "version": "unknown"}


def to_nix_expr(
    provider_reqs: Dict, provider_imports: Dict, provider_versions: Dict, fh: TextIO
) -> None:
    fh.write("# Warning: generated by update-providers.py, do not update manually\n")
    fh.write("{\n")
    for provider, reqs in sorted(provider_reqs.items()):
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
        headers = {}
        token = os.environ.get("GITHUB_TOKEN")
        if token:
            headers["Authorization"] = f"Bearer {token}"

        # Get the SHA of the 'providers' directory for the given version
        req = Request(f"https://api.github.com/repos/apache/airflow/contents/?ref={version}", headers=headers)
        with urlopen(req) as response:
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
        req = Request(f"https://api.github.com/repos/apache/airflow/git/trees/{providers_dir_sha}?recursive=1", headers=headers)
        with urlopen(req) as response:
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
        logging.error("Error fetching provider list from GitHub: %s", e)
        sys.exit(1)

    return sorted(providers)


def get_all_providers(source_dir: Optional[Path], version: str) -> List[str]:
    if source_dir:
        providers_dir = source_dir / "providers"
        providers = []
        for p in providers_dir.glob("**/pyproject.toml"):
            rel = p.relative_to(providers_dir).parent
            rel_str = str(rel)
            if rel_str and not rel_str.startswith("tests"):
                providers.append(rel_str.replace("/", "."))
        return sorted(providers)
    return get_all_providers_from_github(version)


def main() -> None:
    logging.basicConfig(level=logging.INFO)
    version = get_version()
    packages = dump_packages()
    logging.info("Generating providers.nix for version %s", version)

    source_dir = get_source_dir()
    if source_dir:
        logging.info("Using local source at %s", source_dir)
    else:
        logging.info("Local source not available; fetching from GitHub API")

    provider_names = get_all_providers(source_dir, version)

    # Parse all pyproject.toml files once in a single pass
    parsed_providers = {
        name: parse_pyproject_toml(source_dir, version, name)
        for name in provider_names
    }

    provider_reqs = {}
    cross_provider_deps = {}
    for provider, data in parsed_providers.items():
        provider_reqs[provider] = list(
            provider_reqs_to_attr_paths(data["deps"], packages)
        ) + EXTRA_REQS.get(provider, [])
        cross_provider_deps[provider] = data["cross-providers-deps"]

    transitive_provider_reqs = {}
    for provider in provider_reqs:
        transitive_provider_reqs[provider] = get_cross_provider_reqs(
            provider, provider_reqs, cross_provider_deps
        )

    provider_imports = {name: data["imports"] for name, data in parsed_providers.items()}
    provider_versions = {name: data["version"] for name, data in parsed_providers.items()}

    with open(os.path.join(os.path.dirname(sys.argv[0]), "providers.nix"), "w") as fh:
        to_nix_expr(transitive_provider_reqs, provider_imports, provider_versions, fh)


if __name__ == "__main__":
    main()
