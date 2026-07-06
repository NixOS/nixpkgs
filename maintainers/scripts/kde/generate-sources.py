#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages(ps: [ ps.beautifulsoup4 ps.click ps.httpx ps.jinja2 ps.packaging ps.pyyaml ])" nix-update
import base64
import binascii
import hashlib
import json
import pathlib
import subprocess
from urllib.parse import urljoin, urlparse

import bs4
import click
import httpx
import jinja2
import packaging.version as v

import utils


LEAF_TEMPLATE = jinja2.Template('''
{ mkKdeDerivation }:
mkKdeDerivation {
  pname = "{{ pname }}";
}
'''.strip())

ROOT_TEMPLATE = jinja2.Template('''
{ callPackage }:
{
  {%- for p in packages %}
  {{ p }} = callPackage ./{{ p }} { };
  {%- endfor %}
}
'''.strip())

PROJECTS_WITH_RUST = {
    "akonadi-search",
    "angelfish",
    "kdepim-addons",
}

def to_sri(hash):
    raw = binascii.unhexlify(hash)
    b64 = base64.b64encode(raw).decode()
    return f"sha256-{b64}"


@click.command
@click.argument(
    "pkgset",
    type=click.Choice(["frameworks", "gear", "plasma"]),
    required=True
)
@click.argument(
    "version",
    type=str,
    required=True
)
@click.option(
    "--nixpkgs",
    type=click.Path(
        exists=True,
        file_okay=False,
        resolve_path=True,
        writable=True,
        path_type=pathlib.Path,
    ),
    default=pathlib.Path(__file__).parent.parent.parent.parent
)
@click.option(
    "--sources-url",
    type=str,
    default=None,
)
def main(pkgset: str, version: str, nixpkgs: pathlib.Path, sources_url: str | None):
    root_dir = nixpkgs / "pkgs/kde"
    set_dir = root_dir / pkgset
    generated_dir = root_dir / "generated"
    metadata = utils.KDERepoMetadata.from_json(generated_dir)

    if sources_url is None:
        set_url = {
            "frameworks": f"frameworks/{version}/",
            "gear": f"release-service/{version}/src/",
            "plasma": f"plasma/{version}/",
        }[pkgset]
        sources_url = f"https://download.kde.org/stable/{set_url}"

    client = httpx.Client()
    sources = client.get(sources_url)
    sources.raise_for_status()
    bs = bs4.BeautifulSoup(sources.text, features="html.parser")

    results = {}
    projects_to_update_rust = set()
    for item in bs.select("tr")[3:]:
        link = item.select_one("td:nth-child(2) a")
        if not link:
            continue

        project_name, version_and_ext = link.text.rsplit("-", maxsplit=1)

        if project_name not in metadata.projects_by_name:
            print(f"Warning: unknown tarball: {project_name}")

        if project_name in PROJECTS_WITH_RUST:
            projects_to_update_rust.add(project_name)

        if version_and_ext.endswith(".sig"):
            continue

        version = version_and_ext.removesuffix(".tar.xz")

        url = urljoin(sources_url, link.attrs["href"])

        hash = client.get(url + ".sha256").text.strip()

        if hash == "Hash type not supported":
            print(f"{url} missing hash on CDN, downloading...")
            hasher = hashlib.sha256()
            with client.stream("GET", url, follow_redirects=True) as r:
                for data in r.iter_bytes():
                    hasher.update(data)
            hash = hasher.hexdigest()
        else:
            hash = hash.split(" ", maxsplit=1)[0]

        if existing := results.get(project_name):
            old_version = existing["version"]
            if v.parse(old_version) > v.parse(version):
                print(f"{project_name} {old_version} is newer than {version}, skipping...")
                continue

        results[project_name] = {
            "version": version,
            "url": "mirror://kde" + urlparse(url).path,
            "hash": to_sri(hash)
        }

        pkg_dir = set_dir / project_name
        pkg_file = pkg_dir / "default.nix"

        if not pkg_file.exists():
            print(f"Generated new package: {pkgset}/{project_name}")
            pkg_dir.mkdir(parents=True, exist_ok=True)
            with pkg_file.open("w") as fd:
                fd.write(LEAF_TEMPLATE.render(pname=project_name) + "\n")

    set_dir.mkdir(parents=True, exist_ok=True)
    with (set_dir / "default.nix").open("w") as fd:
        fd.write(ROOT_TEMPLATE.render(packages=sorted(results.keys())) + "\n")

    sources_dir = generated_dir / "sources"
    sources_dir.mkdir(parents=True, exist_ok=True)
    with (sources_dir / f"{pkgset}.json").open("w") as fd:
        json.dump(results, fd, indent=2)

    for project_name in projects_to_update_rust:
            print(f"Updating cargoDeps hash for {pkgset}/{project_name}...")
            subprocess.run([
                "nix-update",
                f"kdePackages.{project_name}",
                "--version",
                "skip",
                "--override-filename",
                pkg_file
            ])


if __name__ == "__main__":
    main()  # type: ignore
