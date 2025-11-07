#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i python3 -p "music-assistant.python.withPackages (ps: music-assistant.dependencies ++ (with ps; [ jinja2 packaging ]))" -p nixfmt pyright ruff isort
import asyncio
import json
import os.path
import re
import sys
import tarfile
import tempfile
from dataclasses import dataclass, field
from functools import cache
from io import BytesIO
from pathlib import Path
from subprocess import check_output, run
from typing import Dict, Final, List, Optional, Set, Union, cast
from urllib.request import urlopen

from jinja2 import Environment
from mashumaro.exceptions import MissingField
from music_assistant_models.provider import ProviderManifest  # type: ignore
from packaging.requirements import Requirement

TEMPLATE = """# Do not edit manually, run ./update-providers.py

{
  version = "{{ version }}";
  providers = {
{%- for provider in providers | sort(attribute='domain') %}
    {{ provider.domain }} = {% if provider.available %}ps: with ps;{% else %}ps:{% endif %} [
{%- for requirement in provider.available | sort %}
      {{ requirement }}
{%- endfor %}
    ];{% if provider.missing %} # missing {{ ", ".join(provider.missing) }}{% endif %}
{%- endfor %}
  };
}

"""


ROOT: Final = (
    check_output(
        [
            "git",
            "rev-parse",
            "--show-toplevel",
        ]
    )
    .decode()
    .strip()
)

PACKAGE_SET = "music-assistant.python.pkgs"
PACKAGE_MAP = {
    "git+https://github.com/MarvinSchenkel/pytube.git": "pytube",
}


EXTRA_DEPS = {
    "ytmusic": [
        # https://github.com/music-assistant/server/blob/2.5.8/music_assistant/providers/ytmusic/__init__.py#L120
        "bgutil-ytdlp-pot-provider",
        "yt-dlp",
    ],
}


def run_sync(cmd: List[str]) -> None:
    print(f"$ {' '.join(cmd)}")
    process = run(cmd)

    if process.returncode != 0:
        sys.exit(1)


async def check_async(cmd: List[str]) -> str:
    print(f"$ {' '.join(cmd)}")
    process = await asyncio.create_subprocess_exec(
        *cmd, stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE
    )
    stdout, stderr = await process.communicate()

    if process.returncode != 0:
        error = stderr.decode()
        raise RuntimeError(f"{cmd[0]} failed: {error}")

    return stdout.decode().strip()


class Nix:
    base_cmd: Final = [
        "nix",
        "--show-trace",
        "--extra-experimental-features",
        "nix-command",
    ]

    @classmethod
    async def _run(cls, args: List[str]) -> Optional[str]:
        return await check_async(cls.base_cmd + args)

    @classmethod
    async def eval(cls, expr: str) -> Union[List, Dict, int, float, str, bool]:
        response = await cls._run(["eval", "-f", f"{ROOT}/default.nix", "--json", expr])
        if response is None:
            raise RuntimeError("Nix eval expression returned no response")
        try:
            return json.loads(response)
        except (TypeError, ValueError):
            raise RuntimeError("Nix eval response could not be parsed from JSON")


async def get_provider_manifests(version: str = "master") -> List:
    manifests = []
    with tempfile.TemporaryDirectory() as tmp:
        with urlopen(
            f"https://github.com/music-assistant/music-assistant/archive/refs/tags/{version}.tar.gz"
        ) as response:
            tarfile.open(fileobj=BytesIO(response.read())).extractall(
                tmp, filter="data"
            )

        basedir = Path(os.path.join(tmp, f"server-{version}"))
        sys.path.append(str(basedir))

        for fn in basedir.glob("**/manifest.json"):
            try:
                manifests.append(await ProviderManifest.parse(str(fn)))
            except MissingField as ex:
                print(f"Error parsing {fn}", ex)

    return manifests


@cache
def packageset_attributes():
    output = check_output(
        [
            "nix-env",
            "-f",
            ROOT,
            "-qa",
            "-A",
            "music-assistant.python.pkgs",
            "--arg",
            "config",
            "{ allowAliases = false; }",
            "--json",
        ]
    )
    return json.loads(output)


class TooManyMatches(Exception):
    pass


class NoMatch(Exception):
    pass


def resolve_package_attribute(package: str) -> str:
    pattern = re.compile(rf"^music-assistant\.python\.pkgs\.{package}$", re.I)
    packages = packageset_attributes()
    matches = []
    for attr in packages.keys():
        if pattern.match(attr):
            matches.append(attr.split(".")[-1])

    if len(matches) > 1:
        raise TooManyMatches(
            f"Too many matching attributes for {package}: {' '.join(matches)}"
        )
    if not matches:
        raise NoMatch(f"No matching attribute for {package}")

    return matches.pop()


async def get_package_version(package: str) -> str:
    version = cast(str, await Nix.eval(f"{PACKAGE_SET}.{package}.version"))
    return version


@dataclass
class Provider:
    domain: str
    available: list[str] = field(default_factory=list)
    missing: list[str] = field(default_factory=list)

    def __eq__(self, other):
        return self.domain == other.domain

    def __hash__(self):
        return hash(self.domain)


async def resolve_providers(manifests) -> Set:
    errors = []
    providers = set()
    for manifest in manifests:
        provider = Provider(manifest.domain)
        requirements = manifest.requirements + EXTRA_DEPS.get(manifest.domain, [])
        for requirement in requirements:
            # allow substituting requirement specifications that packaging cannot parse
            if requirement in PACKAGE_MAP:
                requirement = PACKAGE_MAP[requirement]

            requirement = Requirement(requirement)
            try:
                attr = resolve_package_attribute(requirement.name)
                provider.available.append(attr)
            except TooManyMatches as ex:
                print(ex, file=sys.stderr)
                provider.missing.append(requirement.name)
                continue
            except NoMatch:
                provider.missing.append(requirement.name)
                continue

            version = await get_package_version(attr)
            if version not in requirement.specifier:
                errors.append(f"{requirement} not satisifed by version {version}")
        providers.add(provider)
    if errors:
        print("\n - ", end="")
        print("\n - ".join(errors))
    return providers


def render(outpath: str, version: str, providers: Set):
    env = Environment()
    template = env.from_string(TEMPLATE)
    template.stream(version=version, providers=providers).dump(outpath)


async def main():
    version: str = cast(str, await Nix.eval("music-assistant.version"))
    manifests = await get_provider_manifests(version)
    providers = await resolve_providers(manifests)

    outpath = os.path.join(ROOT, "pkgs/by-name/mu/music-assistant/providers.nix")
    render(outpath, version, providers)

    run_sync(["nixfmt", outpath])


if __name__ == "__main__":
    run_sync(["pyright", __file__])
    run_sync(["ruff", "check", "--ignore=E501", __file__])
    run_sync(["isort", __file__])
    run_sync(["ruff", "format", __file__])
    asyncio.run(main())
