#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p nix nix-prefetch-github "python3.withPackages (ps: [ ps.pydantic ps.requests ps.stackprinter ])"

import argparse
import base64
import binascii
import functools
import os
import re
import shlex
import subprocess
import sys
from concurrent.futures import Executor, ThreadPoolExecutor, as_completed
from pathlib import Path
from typing import Any, Callable, Generator, List, Tuple

import requests
import stackprinter
from pydantic import (
    BaseModel,
    ConfigDict,
    Field,
    GetCoreSchemaHandler,
    PositiveInt,
    RootModel,
    TypeAdapter,
)
from pydantic_core import CoreSchema, core_schema
from requests.adapters import HTTPAdapter, Retry

stackprinter.set_excepthook(style="darkbg2")


eprint = functools.partial(print, file=sys.stderr)
json_path = Path(__file__).parent / "source.json"
hash_re = re.compile(r"\bgot:\s+(\S+)")
version_re = re.compile(r"version/(\d{4})\.(\d{1,2})\.(\d+)")


class Hash(str):
    """A Nix sha256 SRI hash.

    The content is validated on construction to always contain a valid hash.

    An empty input string will be replaced with the "all zero" fake hash.
    """

    FAKE: "Hash"

    def __new__(cls, v: str) -> "Hash":
        return str.__new__(cls, Hash.validate(v))

    def is_fake(self) -> bool:
        return self == self.FAKE

    @classmethod
    def __get_pydantic_core_schema__(
        cls, source_type: Any, handler: GetCoreSchemaHandler
    ) -> CoreSchema:
        return core_schema.no_info_after_validator_function(cls, handler(str))

    @staticmethod
    def validate(v: object) -> str:
        if not isinstance(v, str):
            raise ValueError(f"Expected str, go {type(v)}")

        if not v:
            return Hash.FAKE

        if not v.startswith("sha256-"):
            raise ValueError("Expected hash to start with 'sha256-'")

        try:
            b = base64.b64decode(v.removeprefix("sha256-"), validate=True)
        except binascii.Error as e:
            raise ValueError(f"Invalid hash content: {e}")
        except ValueError as e:
            raise ValueError(f"Invalid hash content: {e}")

        if len(b) != 32:
            raise ValueError(f"Invalid hash length: {len(b) * 8} bits")

        return v


Hash.FAKE = Hash("sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=")


class Model(BaseModel):
    """Custom BaseModel with shared config values"""

    model_config = ConfigDict(serialize_by_alias=True)


def create_http_session() -> requests.Session:
    retries = Retry(total=5, backoff_factor=0.5, status_forcelist=[500, 502, 503, 504])
    session = requests.Session()
    session.headers["User-Agent"] = (
        "nixpkgs-authentik-update/1 (https://github.com/NixOS/nixpkgs)"
    )
    session.mount("http://", HTTPAdapter(max_retries=retries))
    session.mount("https://", HTTPAdapter(max_retries=retries))
    return session


def run_command_text(args: list[str], *, stderr_prefix: str = "") -> str:
    eprint(f"{stderr_prefix}# {shlex.join(args)}")
    process = subprocess.run(args, capture_output=True, check=True, text=True)
    for line in process.stderr.splitlines():
        eprint(f"{stderr_prefix}{line}")

    return process.stdout


def get_or_update_component_hash(
    current: Hash, component: str, extra_args: list[str], *, system: str | None = None
) -> Hash:
    if not current.is_fake():
        return current

    system_args = []
    if s := system:
        system_args = ["--argstr", "system", s]

    if system is not None:
        prefix = f"{component}({system}): "
    else:
        prefix = f"{component}: "

    args = [
        "nix-build",
        "--keep-going",
        "--no-link",
        "-A",
        f"authentik.components.{component}",
        *system_args,
        *extra_args,
    ]
    eprint(f"{prefix}# {shlex.join(args)}")
    with subprocess.Popen(
        args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True
    ) as process:
        hashes = []
        for line in process.stdout or ():
            eprint(f"{prefix}{line}", end="")
            if match := hash_re.search(line):
                hashes.append(match[1])

    eprint(prefix)
    if len(hashes) == 1:
        eprint(f"{prefix}Found the new hash {hashes[0]}")
        return Hash(hashes[0])
    else:
        eprint(f"{prefix}Unable to determine the new hash (found {hashes})")
        return Hash.FAKE


class NixPrefetchGithubOutput(Model):
    owner: str
    repo: str
    rev: str
    hash: Hash


class Authentik(Model):
    version: str = ""
    hash: Hash = Hash.FAKE

    def update_to(self, new_version: str, *, force: bool = False) -> "Authentik":
        hash = self.hash
        if self.version != new_version or self.hash.is_fake() or force:
            args = [
                "nix-prefetch-github",
                "goauthentik",
                "authentik",
                "--rev",
                f"version/{new_version}",
                "-v",
            ]
            output = run_command_text(args, stderr_prefix="nix-prefetch-github: ")
            hash = NixPrefetchGithubOutput.model_validate_json(output).hash

        return Authentik(version=new_version, hash=hash)


class Systems(Model):
    aarch64Linux: Hash = Field(alias="aarch64-linux", default=Hash.FAKE)
    x86_64Linux: Hash = Field(alias="x86_64-linux", default=Hash.FAKE)

    def is_any_hash_fake(self) -> bool:
        return self.aarch64Linux.is_fake() or self.x86_64Linux.is_fake()


Worker = Callable[[], Hash]
Updater = Callable[["State", Hash], Any]


class State(Model):
    authentik: Authentik = Field(default_factory=lambda: Authentik())
    coreCargoHash: Hash = Hash.FAKE
    serverVendorHash: Hash = Hash.FAKE
    webuiHashes: Systems = Field(default_factory=lambda: Systems())

    def update_core_cargo_hash(self, extra_args: list[str]) -> tuple[Worker, Updater]:
        return (
            lambda: get_or_update_component_hash(
                self.coreCargoHash, "core.cargoDeps", extra_args
            ),
            lambda state, hash: setattr(state, "coreCargoHash", hash),
        )

    def update_server_vendor_hash(
        self, extra_args: list[str]
    ) -> tuple[Worker, Updater]:
        return (
            lambda: get_or_update_component_hash(
                self.serverVendorHash, "server.goModules", extra_args
            ),
            lambda state, hash: setattr(state, "serverVendorHash", hash),
        )

    def update_webui_hash(
        self, attr: str, extra_args: list[str]
    ) -> tuple[Worker, Updater]:
        system = Systems.model_fields[attr].alias
        hash = getattr(self.webuiHashes, attr)
        return (
            lambda: get_or_update_component_hash(
                hash, "webui-deps", extra_args, system=system
            ),
            lambda state, hash: setattr(state.webuiHashes, attr, hash),
        )

    def update_hashes(self, executor: Executor, extra_args: list[str]) -> "State":
        fns = [
            self.update_core_cargo_hash(extra_args),
            self.update_server_vendor_hash(extra_args),
            self.update_webui_hash("aarch64Linux", extra_args),
            self.update_webui_hash("x86_64Linux", extra_args),
        ]
        future_to_update = {executor.submit(work): update for work, update in fns}
        state = self.model_copy()
        for future in as_completed(future_to_update):
            future_to_update[future](state, future.result())
        return state

    def is_any_hash_fake(self) -> bool:
        return (
            self.authentik.hash.is_fake()
            or self.coreCargoHash.is_fake()
            or self.serverVendorHash.is_fake()
            or self.webuiHashes.is_any_hash_fake()
        )


class GithubRelease(Model):
    """Minimal subset of attributes required of a release.

    All other attributes are discarded during validation."""

    tag_name: str


class GithubReleases(RootModel[List[GithubRelease]]):
    def lastest_version(
        self, *, same_minor: Tuple[int, int] | None = None
    ) -> str | None:
        if version := next(
            iter(sorted(self.versions(same_minor=same_minor), reverse=True)), None
        ):
            return ".".join(map(str, version))

        return None

    def versions(
        self, *, same_minor: Tuple[int, int] | None = None
    ) -> Generator[Tuple[int, int, int]]:
        for release in self.root:
            if match := version_re.fullmatch(release.tag_name):
                version = (int(match[1]), int(match[2]), int(match[3]))
                if same_minor is not None and same_minor != version[:2]:
                    continue
                yield version

        return None


class UpdateNixChange(Model):
    """A subset of the attributes expected by `update.nix` for a change entry."""

    attrPath: str
    newVersion: str


class UpdateNixChanges(RootModel[List[UpdateNixChange]]):
    """Toplevel structure expected by `update.nix` in `commit` mode."""

    pass


def parse_version(s: str) -> tuple[int, int] | tuple[int, int, int]:
    it = map(int, s.split("."))
    major, minor, patch = next(it), next(it), next(it, None)
    if next(it, None) is not None:
        raise ValueError(f"Invalid version string '{s}'")

    if patch is not None:
        return (major, minor, patch)
    return (major, minor)


def strip_common_whitespace_prefix(s: str) -> str:
    """Strip leading whitespace from each line in a multiline string.

    The length of whitespace removed is ths smallest indentation of all lines which do not entirely consist of whitespace.

    This is intended to be similar to Nix indented (''...'') strings.
    """

    if not s:
        return ""
    min_common = -1
    for line in s.splitlines():
        stripped = line.lstrip(" ")
        # ignore whitespace only lines in the calculation
        if not stripped:
            continue
        diff = len(line) - len(stripped)
        if min_common == -1:
            min_common = diff
        else:
            min_common = min(min_common, diff)

    def remove_prefix(line: str) -> str:
        if min_common == -1 or len(line) < min_common:
            return line.lstrip(" ")
        return line[min_common:]

    return "".join(remove_prefix(line) for line in s.splitlines(keepends=True))


assert strip_common_whitespace_prefix("") == ""
assert strip_common_whitespace_prefix("    ") == ""
assert strip_common_whitespace_prefix(" \n  ") == "\n"
assert strip_common_whitespace_prefix("  a\n  b") == "a\nb"
assert strip_common_whitespace_prefix("  a\n\n  b") == "a\n\nb"
assert strip_common_whitespace_prefix("  a\n  \n  b") == "a\n\nb"
assert strip_common_whitespace_prefix("    a\n  \n  b") == "  a\n\nb"
assert strip_common_whitespace_prefix("  a\n  \n    b") == "a\n\n  b"


class HelpFormatter(
    argparse.RawDescriptionHelpFormatter, argparse.ArgumentDefaultsHelpFormatter
):
    """Help message formatter which retains any formatting in descriptions and
    adds default values to argument help."""

    pass


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="update.py",
        formatter_class=HelpFormatter,
        description=strip_common_whitespace_prefix("""
            Authentik updater script

            Create and update the `source.json` file for the `authentik` package.

            The script tries to only update missing component hashes if possible.
            If the `authentik.version` or `authentik.hash` changes, all other hashes are considered missing.

            To assist with building dependencies for different architectures (aarch64-linux and x86_64-linux at the moment),
            the `NIX_BUILD_ARGS` environment variable and all remaining arguments after the first `--` will be passed
            to the `nix-build` commands.

            For example: --builders "buildhost aarch64-linux - 2"
        """).strip(),
    )
    parser.add_argument(
        "-P",
        "--parallel",
        type=TypeAdapter(PositiveInt).validate_python,
        default=5,
        help="The number of parallel `nix-build` processes to run",
    )
    group = parser.add_mutually_exclusive_group()
    group.add_argument("-a", "--authentik", help="Update to this specific version")
    group.add_argument(
        "-p",
        "--patch",
        action="store_true",
        help="Update to the lastest patch of the current minor version",
    )
    group.add_argument(
        "-g",
        "--generate",
        action="store_true",
        help="Don't update the version and only generate missing hashes",
    )
    parser.add_argument(
        "-f", "--force", action="store_true", help="Force recalculation of all hashes"
    )
    parser.add_argument(
        "nix_build_args",
        nargs="*",
        default=[],
        help="Additional arguments passed to `nix-build`",
    )

    return parser


def determine_new_version(
    state: State, *, version: str, generate: bool, patch: bool
) -> str:
    # Fixed version. Any invalid input will fail during `nix-prefetch-github`
    if version:
        parse_version(version)
        return version

    # Don't update, only generate hashes
    elif generate:
        if state.authentik.version:
            return state.authentik.version
        else:
            eprint(
                "Can't perform hash generation without current `source.json` (missing `authentik.version`)"
            )
            sys.exit(1)

    # Latest version based on github releases
    else:
        session = create_http_session()
        releases_content = session.get(
            "https://api.github.com/repos/goauthentik/authentik/releases"
        ).text
        releases = GithubReleases.model_validate_json(releases_content)

        same_minor = None
        if patch:
            # Limit version selection to the same minor as currently in use
            if v := state.authentik.version:
                same_minor = parse_version(v)[:2]
            else:
                eprint(
                    "Can't perform patch version update without current `source.json` (missing `authentik.version`)"
                )
                sys.exit(1)

        target_version = releases.lastest_version(same_minor=same_minor)
        if not target_version:
            s = ""
            if same_minor:
                s = f" for minor version {'.'.join(map(str, same_minor))}"
            eprint(
                f"Could not determine the latest version{s}. Found the following tags on github:\n"
                f"{'\n'.join(r.tag_name for r in releases.root)}"
            )
            sys.exit(1)

        return target_version


def save_state(state: State, note: str) -> None:
    content = state.model_dump_json(indent=2)
    json_path.write_text(f"{content}\n")
    eprint(f"Wrote new `source.json` {note}:\n{content}")


def main() -> None:
    args = build_parser().parse_args()

    nix_build_args = (
        shlex.split(os.environ.get("NIX_BUILD_ARGS", "")) + args.nix_build_args
    )

    # Load current source.json. Validation errors are fatal.
    try:
        with json_path.open() as jsonFile:
            current_state = State.model_validate_json(jsonFile.read())
    except FileNotFoundError:
        # Start with an empty state if the file does not exist
        current_state = State()

    current_version = current_state.authentik.version
    new_version = determine_new_version(
        current_state, version=args.authentik, generate=args.generate, patch=args.patch
    )
    if new_version != current_version:
        if current_version:
            eprint(
                f"Updating `source.json` from '{current_version}' to '{new_version}'"
            )
        else:
            eprint(f"Generating new `source.json` for '{new_version}'")

    # Update the source hash, if necessary
    new_authentik = current_state.authentik.update_to(new_version, force=args.force)
    # If the version/hash changed (or force is set), clear all other hashes
    if current_state.authentik != new_authentik or args.force:
        next_state = State(authentik=new_authentik)
    else:
        next_state = current_state.model_copy(update={"authentik": new_authentik})

    # Save current state, so the following hash generation uses the (potentially) new source hash
    save_state(next_state, "after version/source hash generation")

    # Run the hash generation in parallel
    with ThreadPoolExecutor(max_workers=args.parallel) as executor:
        final_state = next_state.update_hashes(executor, nix_build_args)

    save_state(final_state, "after component hash generation")

    # if any hash is unknown, ensure update.nix doesn't commit the changes
    if final_state.is_any_hash_fake():
        eprint("\nCould not determine all hashes. Automatic update failed.")
        sys.exit(1)

    # using UPDATE_NIX_ATTR_PATH to detect if this is being called from update.nix
    if os.environ.get("UPDATE_NIX_ATTR_PATH"):
        changes = UpdateNixChanges(
            [
                UpdateNixChange(
                    attrPath="authentik,authentik-outposts", newVersion=new_version
                )
            ]
        )
        print(f"{changes.model_dump_json(indent=2)}\n")


if __name__ == "__main__":
    main()
