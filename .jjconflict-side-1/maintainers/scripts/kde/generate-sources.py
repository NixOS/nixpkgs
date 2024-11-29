#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages(ps: [ ps.beautifulsoup4 ps.click ps.httpx ps.jinja2 ps.pyyaml ])"
import base64
import binascii
import json
import pathlib
from typing import Optional
from urllib.parse import urlparse

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
            "frameworks": "kf",
            "gear": "releases",
            "plasma": "plasma",
        }[set]
        sources_url = f"https://kde.org/info/sources/source-{set_url}-{version}/"

    sources = httpx.get(sources_url)
    sources.raise_for_status()
    bs = bs4.BeautifulSoup(sources.text, features="html.parser")

    results = {}
    for item in bs.select("tr")[1:]:
        link = item.select_one("td:nth-child(1) a")
        assert link

        hash = item.select_one("td:nth-child(3) tt")
        assert hash

        project_name, version = link.text.rsplit("-", maxsplit=1)
        if project_name not in metadata.projects_by_name:
            print(f"Warning: unknown tarball: {project_name}")

        results[project_name] = {
            "version": version,
            "url": "mirror://kde" + urlparse(link.attrs["href"]).path,
            "hash": to_sri(hash.text)
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
