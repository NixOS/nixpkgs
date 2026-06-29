#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p nix nix-prefetch-github "python3.withPackages (ps: [ ps.pydantic ps.requests ps.stackprinter ])"

import argparse
import base64
import binascii
import functools
import json
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
    """A Nix sha256 SRI hash."""

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
            raise ValueError(f"Expected str, got {type(v)}")

        if not v:
            return Hash.FAKE

        if not v.startswith("sha256-"):
            raise ValueError("Expected hash to start with 'sha256-'")

        try:
            b = base64.b64decode(v.removeprefix("sha256-"), validate=True)
        except (binascii.Error, ValueError) as e:
            raise ValueError(f"Invalid hash content: {e}")

        if len(b) != 32:
            raise ValueError(f"Invalid hash length: {len(b) * 8} bits")

        return v


Hash.FAKE = Hash("sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=")


class Model(BaseModel):
    model_config = ConfigDict(serialize_by_alias=True)


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
    authentik: Authentik = Field(default_factory=Authentik)
    workerCargoHash: Hash = Hash.FAKE
    proxyVendorHash: Hash = Hash.FAKE
    websiteNpmHash: Hash = Hash.FAKE
    webuiHashes: Systems = Field(default_factory=Systems)

    def update_worker_cargo_hash(self, extra_args: list[str]) -> tuple[Worker, Updater]:
        return (
            lambda: get_or_update_hash(
                self.workerCargoHash,
                "workerCargoHash",
                "updateDeps.workerCargoDeps",
                extra_args,
            ),
            lambda state, hash: setattr(state, "workerCargoHash", hash),
        )

    def update_proxy_vendor_hash(self, extra_args: list[str]) -> tuple[Worker, Updater]:
        return (
            lambda: get_or_update_hash(
                self.proxyVendorHash,
                "proxyVendorHash",
                "updateDeps.proxyGoModules",
                extra_args,
            ),
            lambda state, hash: setattr(state, "proxyVendorHash", hash),
        )

    def update_website_npm_hash(self, extra_args: list[str]) -> tuple[Worker, Updater]:
        return (
            lambda: get_or_update_hash(
                self.websiteNpmHash,
                "websiteNpmHash",
                "updateDeps.websiteNpmDeps",
                extra_args,
            ),
            lambda state, hash: setattr(state, "websiteNpmHash", hash),
        )

    def update_webui_hash(
        self, attr: str, extra_args: list[str]
    ) -> tuple[Worker, Updater]:
        system = Systems.model_fields[attr].alias
        hash = getattr(self.webuiHashes, attr)
        return (
            lambda: get_or_update_hash(
                hash,
                f"webuiHashes.{system}",
                "updateDeps.webuiDeps",
                extra_args,
                system=system,
            ),
            lambda state, hash: setattr(state.webuiHashes, attr, hash),
        )

    def update_hashes(self, executor: Executor, extra_args: list[str]) -> "State":
        fns = [
            self.update_worker_cargo_hash(extra_args),
            self.update_proxy_vendor_hash(extra_args),
            self.update_website_npm_hash(extra_args),
            self.update_webui_hash("aarch64Linux", extra_args),
            self.update_webui_hash("x86_64Linux", extra_args),
        ]
        future_to_update = {executor.submit(work): update for work, update in fns}
        state = self.model_copy(deep=True)
        for future in as_completed(future_to_update):
            future_to_update[future](state, future.result())
        return state

    def is_any_hash_fake(self) -> bool:
        return (
            self.authentik.hash.is_fake()
            or self.workerCargoHash.is_fake()
            or self.proxyVendorHash.is_fake()
            or self.websiteNpmHash.is_fake()
            or self.webuiHashes.is_any_hash_fake()
        )


class GithubRelease(Model):
    tag_name: str


class GithubReleases(RootModel[List[GithubRelease]]):
    def latest_version(
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


class UpdateNixChange(Model):
    attrPath: str
    newVersion: str


class UpdateNixChanges(RootModel[List[UpdateNixChange]]):
    pass


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


def get_or_update_hash(
    current: Hash,
    name: str,
    attr: str,
    extra_args: list[str],
    *,
    system: str | None = None,
) -> Hash:
    if not current.is_fake():
        return current

    system_args = []
    if system is not None:
        system_args = ["--argstr", "system", system]

    prefix = f"{name}: "
    args = [
        "nix-build",
        "--keep-going",
        "--no-link",
        "-A",
        f"authentik.{attr}",
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

    eprint(f"{prefix}Unable to determine the new hash (found {hashes})")
    return Hash.FAKE


def parse_version(s: str) -> tuple[int, int] | tuple[int, int, int]:
    it = map(int, s.split("."))
    major, minor, patch = next(it), next(it), next(it, None)
    if next(it, None) is not None:
        raise ValueError(f"Invalid version string '{s}'")

    if patch is not None:
        return (major, minor, patch)
    return (major, minor)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Create and update source.json for the authentik package.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "-a",
        "--authentik",
        help="Update to this specific authentik version.",
    )
    group = parser.add_mutually_exclusive_group()
    group.add_argument(
        "-p",
        "--patch",
        action="store_true",
        help="Update to the latest patch of the current minor version.",
    )
    group.add_argument(
        "-g",
        "--generate",
        action="store_true",
        help="Do not look up a newer version; generate missing hashes only.",
    )
    parser.add_argument(
        "-f", "--force", action="store_true", help="Force recalculation of all hashes."
    )
    parser.add_argument(
        "-P",
        "--parallel",
        type=TypeAdapter(PositiveInt).validate_python,
        default=5,
        help="The number of parallel nix-build processes to run.",
    )
    parser.add_argument(
        "nix_build_args",
        nargs="*",
        default=[],
        help="Additional arguments passed to nix-build.",
    )
    return parser


def determine_new_version(
    state: State, *, version: str | None, generate: bool, patch: bool
) -> str:
    if version:
        parse_version(version)
        return version

    if generate:
        if state.authentik.version:
            return state.authentik.version
        eprint("Can't generate hashes without source.json authentik.version")
        sys.exit(1)

    session = create_http_session()
    releases_content = session.get(
        "https://api.github.com/repos/goauthentik/authentik/releases"
    ).text
    releases = GithubReleases.model_validate_json(releases_content)

    same_minor = None
    if patch:
        if state.authentik.version:
            same_minor = parse_version(state.authentik.version)[:2]
        else:
            eprint("Can't update patch version without source.json authentik.version")
            sys.exit(1)

    target_version = releases.latest_version(same_minor=same_minor)
    if not target_version:
        eprint("Could not determine the latest authentik release")
        sys.exit(1)
    return target_version


def load_state() -> State:
    try:
        return State.model_validate_json(json_path.read_text())
    except FileNotFoundError:
        return State()


def save_state(state: State, note: str) -> None:
    content = state.model_dump(mode="json", by_alias=True)
    json_path.write_text(f"{json.dumps(content, indent=2)}\n")
    eprint(f"Wrote source.json {note}")


def main() -> None:
    args = build_parser().parse_args()
    nix_build_args = (
        shlex.split(os.environ.get("NIX_BUILD_ARGS", "")) + args.nix_build_args
    )

    current_state = load_state()
    new_version = determine_new_version(
        current_state,
        version=args.authentik,
        generate=args.generate,
        patch=args.patch,
    )

    new_authentik = current_state.authentik.update_to(new_version, force=args.force)
    if current_state.authentik != new_authentik or args.force:
        next_state = State(authentik=new_authentik)
    else:
        next_state = current_state.model_copy(update={"authentik": new_authentik})

    save_state(next_state, "after version/source hash generation")

    with ThreadPoolExecutor(max_workers=args.parallel) as executor:
        final_state = next_state.update_hashes(executor, nix_build_args)

    save_state(final_state, "after dependency hash generation")

    if final_state.is_any_hash_fake():
        eprint("Could not determine all hashes. Automatic update failed.")
        sys.exit(1)

    if os.environ.get("UPDATE_NIX_ATTR_PATH"):
        changes = UpdateNixChanges(
            [
                UpdateNixChange(
                    attrPath="authentik,authentik-outposts",
                    newVersion=new_version,
                )
            ]
        )
        print(changes.model_dump_json(indent=2))


if __name__ == "__main__":
    main()
