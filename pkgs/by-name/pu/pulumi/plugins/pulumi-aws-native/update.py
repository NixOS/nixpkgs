import contextlib
import json
import os
import pathlib
import shutil
import subprocess
import sys
import tempfile
import typing
import urllib.parse

import requests

GITHUB_TOKEN = os.environ.get("GITHUB_TOKEN")

GITHUB_OWNER = "pulumi"
GITHUB_REPO = "pulumi-aws-native"

DEFAULT_ATTR_PATH = "pulumiPackages.pulumi-aws-native"

PACKAGE_EXPR = """p: {
  dir = builtins.dirOf p.meta.position;
  version = p.version;
  sourceHash = p.src.src.outputHash;
  vendorHash = p.goModules.outputHash;
  docsVersion = p.src.docsVersion;
  docsHash = p.src.docs.outputHash;
}"""


@contextlib.contextmanager
def pushd(pwd: str) -> typing.Iterator[None]:
    oldpwd = pathlib.Path.cwd()
    os.chdir(pwd)
    try:
        yield
    finally:
        os.chdir(oldpwd)


def replace_in_file(
    file_path: pathlib.Path,
    replacements: dict[str, str],
) -> None:
    file_contents = file_path.read_text()
    for old, new in replacements.items():
        if old == new:
            continue
        updated_file_contents = file_contents.replace(old, new)
        # A dumb way to check that we’ve actually replaced the string.
        if file_contents == updated_file_contents:
            sys.stderr.write(f"no string to replace: {old} → {new}")
            sys.exit(1)
        file_contents = updated_file_contents
    with tempfile.NamedTemporaryFile(mode="w") as t:
        t.write(file_contents)
        t.flush()
        shutil.copyfile(t.name, file_path)


def prefetch_go_modules(nixpkgs_path: str, attr_path: str) -> str:
    with tempfile.TemporaryDirectory() as work_dir, pushd(work_dir):
        subprocess.run(
            [
                "nix",
                "--extra-experimental-features",
                "nix-command",
                "develop",
                "--file",
                nixpkgs_path,
                attr_path,
                "--command",
                "bash",
                "-e",
                "-u",
                "-c",
                'source -- "$stdenv/setup";mkdir outputs;genericBuild',
            ],
            check=True,
        )
        return subprocess.run(
            [
                "nix",
                "--extra-experimental-features",
                "nix-command",
                "hash",
                "path",
                "outputs/out",
            ],
            stdout=subprocess.PIPE,
            text=True,
            check=True,
        ).stdout.rstrip()


def github_get(path: str) -> typing.Any:
    url = f"https://api.github.com{path}"
    headers = (
        {"Authorization": f"Bearer {GITHUB_TOKEN}"}
        if GITHUB_TOKEN is not None
        else {}
    )
    response = requests.get(url, headers=headers)
    response.raise_for_status()
    return response.json()


def github_latest_release_tag_name(owner: str, repo: str) -> str:
    path = f"/repos/{owner}/{repo}/releases/latest"
    tag_name = github_get(path).get("tag_name")
    assert isinstance(tag_name, str)
    return tag_name


nixpkgs_path = subprocess.run(
    [
        "git",
        "rev-parse",
        "--show-toplevel",
    ],
    stdout=subprocess.PIPE,
    text=True,
    check=True,
).stdout.rstrip()

attr_path = os.getenv("UPDATE_NIX_ATTR_PATH", DEFAULT_ATTR_PATH)

package_attrs = json.loads(
    subprocess.run(
        [
            "nix",
            "--extra-experimental-features",
            "nix-command",
            "eval",
            "--json",
            "--file",
            nixpkgs_path,
            "--apply",
            PACKAGE_EXPR,
            "--",
            attr_path,
        ],
        stdout=subprocess.PIPE,
        text=True,
        check=True,
    ).stdout
)

release_tag = github_latest_release_tag_name(GITHUB_OWNER, GITHUB_REPO)

old_version = package_attrs["version"]
new_version = release_tag.removeprefix("v")

if new_version == old_version:
    sys.exit()

project_url = f"https://github.com/{GITHUB_OWNER}/{GITHUB_REPO}"
version_quoted = urllib.parse.quote(new_version)
flake_url = f"git+{project_url}?ref=refs/tags/v{version_quoted}&submodules=1"
prefetched_source = json.loads(
    subprocess.run(
        [
            "nix",
            "--extra-experimental-features",
            "nix-command flakes",
            "flake",
            "prefetch",
            "--json",
            flake_url,
        ],
        stdout=subprocess.PIPE,
        text=True,
        check=True,
    ).stdout
)

old_source_hash = package_attrs["sourceHash"]
new_source_hash = prefetched_source["hash"]

store_path = prefetched_source["storePath"]

docs_version_path = pathlib.Path(store_path) / ".docs.version"

old_docs_version = package_attrs["docsVersion"]
new_docs_version = docs_version_path.read_text().rstrip()

assert len(new_docs_version) == 40  # Git SHA1

docs_url = (
    f"https://github.com/cdklabs/awscdk-service-spec/raw/{new_docs_version}"
    "/sources/CloudFormationDocumentation/CloudFormationDocumentation.json"
)

with tempfile.NamedTemporaryFile(mode="wb") as t:
    response = requests.get(docs_url, stream=True, allow_redirects=True)
    response.raw.decode_content = True
    shutil.copyfileobj(response.raw, t)
    t.flush()
    docs_file_hash = subprocess.run(
        [
            "nix",
            "--extra-experimental-features",
            "nix-command",
            "hash",
            "file",
            "--",
            t.name,
        ],
        stdout=subprocess.PIPE,
        text=True,
        check=True,
    ).stdout.rstrip()

old_docs_hash = package_attrs["docsHash"]
new_docs_hash = docs_file_hash

package_dir = package_attrs["dir"]
package_file = pathlib.Path(package_dir) / "package.nix"

replace_in_file(
    package_file,
    {
        f'version = "{old_version}"': f'version = "{new_version}"',
        old_source_hash: new_source_hash,
        old_docs_version: new_docs_version,
        old_docs_hash: new_docs_hash,
    },
)

old_vendor_hash = package_attrs["vendorHash"]
new_vendor_hash = prefetch_go_modules(nixpkgs_path, f"{attr_path}.goModules")

replace_in_file(
    package_file,
    {
        old_vendor_hash: new_vendor_hash,
    },
)
