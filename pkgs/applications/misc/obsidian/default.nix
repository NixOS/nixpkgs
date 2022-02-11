{ stdenv, fetchurl, lib, makeWrapper, electron_13, makeDesktopItem, graphicsmagick
, writeScript }:

let
  electron = electron_13;
  icon = fetchurl {
    url =
      "https://forum.obsidian.md/uploads/default/original/1X/bf119bd48f748f4fd2d65f2d1bb05d3c806883b5.png";
    sha256 = "18ylnbvxr6k4x44c4i1d55wxy2dq4fdppp43a4wl6h6zar0sc9s2";
  };

  desktopItem = makeDesktopItem {
    name = "obsidian";
    desktopName = "Obsidian";
    comment = "Knowledge base";
    icon = "obsidian";
    exec = "obsidian";
    categories = "Office";
  };

  updateScript = writeScript "obsidian-updater" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts

    set -eu -o pipefail

    latestVersion="$(curl -sS https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/desktop-releases.json | jq -r '.latestVersion')"

    update-source-version obsidian "$latestVersion"
  '';

in stdenv.mkDerivation rec {
  pname = "obsidian";
  version = "0.13.23";

  src = fetchurl {
    url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/obsidian-${version}.tar.gz";
    sha256 = "1chxf6vrybjvc64k66a3l5xvv6iv6w8b03pdcrc0pr0nnlwkcf8c";
  };

  nativeBuildInputs = [ makeWrapper graphicsmagick ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    makeWrapper ${electron}/bin/electron $out/bin/obsidian \
      --add-flags $out/share/obsidian/app.asar

    install -m 444 -D resources/app.asar $out/share/obsidian/app.asar
    install -m 444 -D resources/obsidian.asar $out/share/obsidian/obsidian.asar

    install -m 444 -D "${desktopItem}/share/applications/"* \
      -t $out/share/applications/

    for size in 16 24 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      gm convert -resize "$size"x"$size" ${icon} $out/share/icons/hicolor/"$size"x"$size"/apps/obsidian.png
    done

    runHook postInstall
  '';

  passthru.updateScript = updateScript;

  meta = with lib; {
    description =
      "A powerful knowledge base that works on top of a local folder of plain text Markdown files";
    homepage = "https://obsidian.md";
    license = licenses.obsidian;
    maintainers = with maintainers; [ conradmearns zaninime ];
    platforms = [ "x86_64-linux" ];
  };
}
