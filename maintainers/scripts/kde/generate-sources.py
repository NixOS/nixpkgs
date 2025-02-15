#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages(ps: [ ps.beautifulsoup4 ps.click ps.httpx ps.jinja2 ps.pyyaml ])"
import base64
import binascii
import json
import pathlib
from typing import Optional
from urllib.parse import urljoin, urlparse

import bs4
import click
import httpx
import jinja2

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
'''.strip());

def to_sri(hash):
    raw = binascii.unhexlify(hash)
    b64 = base64.b64encode(raw).decode()
    return f"sha256-{b64}"


@click.command
@click.argument(
    "set",
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
def main(set: str, version: str, nixpkgs: pathlib.Path, sources_url: Optional[str]):
    root_dir = nixpkgs / "pkgs/kde"
    set_dir = root_dir / set
    generated_dir = root_dir / "generated"
    metadata = utils.KDERepoMetadata.from_json(generated_dir)

    if sources_url is None:
        set_url = {
            "frameworks": f"frameworks/{version}/",
            "gear": f"release-service/{version}/src/",
            "plasma": f"plasma/{version}/",
        }[set]
        sources_url = f"https://download.kde.org/stable/{set_url}"

    client = httpx.Client()
    sources = client.get(sources_url)
    sources.raise_for_status()
    bs = bs4.BeautifulSoup(sources.text, features="html.parser")

    results = {}
    for item in bs.select("tr")[3:]:
        link = item.select_one("td:nth-child(2) a")
        if not link:
            continue

        project_name, version_and_ext = link.text.rsplit("-", maxsplit=1)

        if project_name not in metadata.projects_by_name:
            print(f"Warning: unknown tarball: {project_name}")

        if version_and_ext.endswith(".sig"):
            continue

        version = version_and_ext.removesuffix(".tar.xz")

        url = urljoin(sources_url, link.attrs["href"])

        hash = client.get(url + ".sha256").text.split(" ", maxsplit=1)[0]
        assert hash

        results[project_name] = {
            "version": version,
            "url": "mirror://kde" + urlparse(url).path,
            "hash": to_sri(hash)
        }

        pkg_dir = set_dir / project_name
        pkg_file = pkg_dir / "default.nix"
        if not pkg_file.exists():
            print(f"Generated new package: {set}/{project_name}")
            pkg_dir.mkdir(parents=True, exist_ok=True)
            with pkg_file.open("w") as fd:
                fd.write(LEAF_TEMPLATE.render(pname=project_name) + "\n")

    set_dir.mkdir(parents=True, exist_ok=True)
    with (set_dir / "default.nix").open("w") as fd:
        fd.write(ROOT_TEMPLATE.render(packages=sorted(results.keys())) + "\n")

    sources_dir = generated_dir / "sources"
    sources_dir.mkdir(parents=True, exist_ok=True)
    with (sources_dir / f"{set}.json").open("w") as fd:
        json.dump(results, fd, indent=2)


if __name__ == "__main__":
    main()  # type: ignore
