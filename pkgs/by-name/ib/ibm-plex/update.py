#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p nix nix-prefetch python3
import json
import subprocess
import urllib.request

fonts_file = "fonts.nix"
fonts_data = json.loads(
    subprocess.check_output(["nix", "eval", "--json", "-f", fonts_file])
)

releases_url = "https://api.github.com/repos/IBM/plex/releases"
releases = json.loads(urllib.request.urlopen(releases_url).read())

for font in fonts_data.keys():
    font_tag = f"@ibm/plex-{font}@"
    font_file = f"plex-{font}.zip"
    current_version = fonts_data.get(font, {}).get("version")

    latest_release = next(
        (r for r in releases if r["tag_name"].lower().startswith(font_tag)), None
    )

    if latest_release is None:
        print(f"No release found for {font}")
        continue

    latest_version = latest_release["tag_name"].split("@")[-1]

    if current_version == latest_version:
        print(f"Font {font} is up-to-date")
        continue

    print(f"Updating {font} from {current_version} to {latest_version}")

    asset = next(
        (
            a
            for a in latest_release["assets"]
            if font_file.lower() in a["name"].lower()
        ),
        None,
    )

    if asset is None:
        print(f"Warning: No asset found for {font}")
        continue

    asset_url = asset["browser_download_url"]

    raw_hash = (
        subprocess.check_output(["nix-prefetch-url", "--unpack", asset_url])
        .decode()
        .strip()
    )

    sri_hash = (
        subprocess.check_output(
            ["nix", "--extra-experimental-features", "nix-command", "hash", "convert", "--hash-algo", "sha256", raw_hash]
        )
        .decode()
        .strip()
    )

    for x, y in zip(
        ["version", "hash", "url"],
        [latest_version, sri_hash, asset_url]
    ):
        if fonts_data[font].get(x) != y:
            fonts_data[font][x] = y


with open(fonts_file, "w") as f:
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
