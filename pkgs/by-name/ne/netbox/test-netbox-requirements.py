"""
Inspired by runtimeDependenciesHook, test that all dependencies specified
in base_requirements.txt are available in the Python environment.
"""

import importlib.metadata
import re
import sys
from argparse import ArgumentParser
from pathlib import Path

from packaging.requirements import Requirement

argparser = ArgumentParser()
argparser.add_argument(
    "base_requirements", help="Path to the base_requirements.txt file"
)


def error(msg: str) -> None:
    print(f"  - {msg}", file=sys.stderr)


def normalize_name(name: str) -> str:
    """
    Normalize package names according to PEP503
    """
    return re.sub(r"[-_.]+", "-", name).lower()


def test_requirement(requirement: Requirement) -> bool:
    """
    Given a requirement specification, tests whether the dependency can
    be resolved in the local environment, and whether it satisfies the
    specified version constraints.
    """
    if requirement.marker and not requirement.marker.evaluate():
        # ignore requirements with incompatible markers
        return True

    package_name = normalize_name(requirement.name)

    try:
        package = importlib.metadata.distribution(requirement.name)
    except importlib.metadata.PackageNotFoundError:
        error(f"{package_name} not installed")
        return False

    # Allow prereleases, to give to give us some wiggle-room
    requirement.specifier.prereleases = True

    if requirement.specifier and package.version not in requirement.specifier:
        error(
            f"{package_name}{requirement.specifier} not satisfied "
            f"by version {package.version}"
        )
        return False

    return True


def get_requirements(base_requirements: Path) -> list[Requirement]:
    return [
        Requirement(requirement.strip())
        for requirement in base_requirements.read_text().splitlines()
        if requirement.strip() != ""
        and not requirement.startswith("#")
        # Documentation building
        and not requirement.startswith(("mkdocs", "zensical"))
    ]


if __name__ == "__main__":
    args = argparser.parse_args()

    requirements = get_requirements(Path(args.base_requirements))

    tests = [test_requirement(requirement) for requirement in requirements]

    if not all(tests):
        sys.exit(1)
