{ stdenv
, fetchurl
, lib
, makeWrapper
, electron
, makeDesktopItem
, imagemagick
, writeScript
, undmg
, unzip
}:
let
  inherit (stdenv.hostPlatform) system;
  pname = "obsidian";
  version = "1.4.14";
  appname = "Obsidian";
  meta = with lib; {
    description = "A powerful knowledge base that works on top of a local folder of plain text Markdown files";
    homepage = "https://obsidian.md";
    downloadPage = "https://github.com/obsidianmd/obsidian-releases/releases";
    license = licenses.obsidian;
    maintainers = with maintainers; [ atila conradmearns zaninime qbit kashw2 ];
  };

  filename = if stdenv.isDarwin then "Obsidian-${version}-universal.dmg" else "obsidian-${version}.tar.gz";
  src = fetchurl {
    url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/${filename}";
    hash = if stdenv.isDarwin then "sha256-5cVKlZJDtXOkil+RohijCcqyJVTrysmqyTvJR0dDAuc=" else "sha256-qFSQer37Nkh3A3oVAFP/0qXzPWJ7SqY2GYA6b1iaYmE=";
  };

  icon = fetchurl {
    url = "https://forum.obsidian.md/uploads/default/original/3X/9/f/9f1b5b46aed533f5386cf276ab2cdce48cbd2e25.png";
    hash = "sha256-GujZZXexbv7aYCzZ7uRvX1uhOQ7vU9+SaGc4ht0qzhI=";
  };

  desktopItem = makeDesktopItem {
    name = "obsidian";
    desktopName = "Obsidian";
    comment = "Knowledge base";
    icon = "obsidian";
    exec = "obsidian %u";
    categories = [ "Office" ];
    mimeTypes = [ "x-scheme-handler/obsidian" ];
  };

  linux = stdenv.mkDerivation {
    inherit pname version src desktopItem icon;
    meta = meta // { platforms = [ "x86_64-linux" "aarch64-linux" ]; };
    nativeBuildInputs = [ makeWrapper imagemagick ];
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      makeWrapper ${electron}/bin/electron $out/bin/obsidian \
        --add-flags $out/share/obsidian/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}"
      install -m 444 -D resources/app.asar $out/share/obsidian/app.asar
      install -m 444 -D resources/obsidian.asar $out/share/obsidian/obsidian.asar
      install -m 444 -D "${desktopItem}/share/applications/"* \
        -t $out/share/applications/
      for size in 16 24 32 48 64 128 256 512; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        convert -resize "$size"x"$size" ${icon} $out/share/icons/hicolor/"$size"x"$size"/apps/obsidian.png
      done
      runHook postInstall
    '';

    passthru.updateScript = writeScript "updater" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq common-updater-scripts
      set -eu -o pipefail
      latestVersion="$(curl -sS https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/desktop-releases.json | jq -r '.latestVersion')"
      update-source-version obsidian "$latestVersion"
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src appname;
    meta = meta // { platforms = [ "x86_64-darwin" "aarch64-darwin" ]; };
    sourceRoot = "${appname}.app";
    nativeBuildInputs = [ makeWrapper undmg unzip ];
    installPhase = ''
      runHook preInstall
      mkdir -p $out/{Applications/${appname}.app,bin}
      cp -R . $out/Applications/${appname}.app
      makeWrapper $out/Applications/${appname}.app/Contents/MacOS/${appname} $out/bin/${pname}
      runHook postInstall
    '';
  };
in
if stdenv.isDarwin then darwin else linux
