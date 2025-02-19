import json
import pathlib
import subprocess
import tempfile
import urllib.request

nixpkgs_path = pathlib.Path(
    subprocess.run(
        [
            "git",
            "rev-parse",
            "--show-toplevel",
        ],
        stdout=subprocess.PIPE,
        text=True,
        check=True,
    ).stdout.rstrip()
)

with tempfile.TemporaryDirectory() as work_dir:
    result_path = pathlib.Path(work_dir) / "result"
    subprocess.run(
        [
            "nix",
            "--extra-experimental-features",
            "nix-command flakes",
            "build",
            "--out-link",
            str(result_path),
            "--file",
            str(nixpkgs_path),
            "pulumiPackages.pulumi-aws-native.src",
        ],
        check=True,
    )
    docs_version = (result_path / ".docs.version").read_text().rstrip()

assert len(docs_version) == 40  # Git SHA1

docs_url = (
    f"https://github.com/cdklabs/awscdk-service-spec/raw/{docs_version}"
    "/sources/CloudFormationDocumentation/CloudFormationDocumentation.json"
)

with tempfile.NamedTemporaryFile(mode="wb") as t:
    urllib.request.urlretrieve(docs_url, t.name)
    docs_hash = subprocess.run(
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

docs_path = pathlib.Path(
    "pkgs",
    "by-name",
    "pu",
    "pulumi",
    "plugins",
    "pulumi-aws-native",
    "docs.json",
)

fetchurl_args = {
    "url": docs_url,
    "hash": docs_hash,
}

(nixpkgs_path / docs_path).write_text(
    json.dumps(fetchurl_args, indent=2) + "\n"
)
