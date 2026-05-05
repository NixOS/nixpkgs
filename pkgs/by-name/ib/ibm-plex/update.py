#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p nix nix-prefetch python3
import json
import subprocess
import urllib.request
import urllib.parse
import argparse

fonts_file = "fonts.nix"
update_file = "fonts_updated.nix"
releases_url = "https://api.github.com/repos/IBM/plex/releases"
rewrite_needed = False

parser = argparse.ArgumentParser(description="Update IBM Plex font versions and hashes")
parser.add_argument(
    "--force-hash",
    action="store_true",
    help="Recompute the hash even if the version hasn't changed",
)
args = parser.parse_args()

fonts_data = json.loads(
    subprocess.check_output(["nix", "eval", "--json", "-f", fonts_file])
)
releases = json.loads(urllib.request.urlopen(releases_url).read())

for font in fonts_data.keys():
    font_tag = "plex-" + font + "@"
    font_file = "plex-" + font + ".zip"
    current_version = fonts_data.get(font, {}).get("version")

    latest_release = next(
        (r for r in releases if font_tag.lower() in r["tag_name"].lower()), None
    )

    if latest_release:
        latest_version = latest_release["tag_name"].split("@")[-1]
        need_update = current_version != latest_version or args.force_hash
        if need_update:
            print(f"Updating {font} from {current_version} to {latest_version}")

            asset = next(
                (
                    a
                    for a in latest_release["assets"]
                    if font_file.lower() in a["name"].lower()
                ),
                None,
            )

            if asset:
                asset_url = urllib.parse.unquote(asset["browser_download_url"])

                raw_hash = (
                    subprocess.check_output(["nix-prefetch-url", "--unpack", asset_url])
                    .decode()
                    .strip()
                )

                sri_hash = (
                    subprocess.check_output(
                        ["nix", "hash", "convert", "--hash-algo", "sha256", raw_hash]
                    )
                    .decode()
                    .strip()
                )

                for x, y in zip(
                    ["version", "hash", "url"], [latest_version, sri_hash, asset_url]
                ):
                    if fonts_data[font][x] != y:
                        fonts_data[font][x] = y
                        rewrite_needed = True
            else:
                print(f"Warning: No asset found for {font}")
        else:
            print(f"{font} is up-to-date")
    else:
        print(f"No release found for {font}")

if rewrite_needed or args.force_hash:
    print(f"Changes detected, rewriting {fonts_file} to {update_file}")
    with open(update_file, "w") as f:
        f.write("{\n")
        for font in sorted(fonts_data.keys()):
            attrs = fonts_data[font]
            f.write(f"  {font} = {{\n")
            for k in sorted(attrs.keys()):
                v = attrs[k]
                if isinstance(v, bool):
                    f.write(f"    {k} = {'true' if v else 'false'};\n")
                else:
                    f.write(f'    {k} = "{v}";\n')
            f.write("  };\n")
        f.write("}\n")
