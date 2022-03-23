{ stdenv
, fetchurl
, lib
, makeWrapper
, electron_16
, makeDesktopItem
, graphicsmagick
, writeScript
, undmg
, unzip
}:
let
  inherit (stdenv.hostPlatform) system;
  pname = "obsidian";
  version = "0.13.31";
  meta = with lib; {
    description = "A powerful knowledge base that works on top of a local folder of plain text Markdown files";
    homepage = "https://obsidian.md";
    downloadPage = "https://github.com/obsidianmd/obsidian-releases/releases";
    license = licenses.obsidian;
    maintainers = with maintainers; [ conradmearns zaninime opeik ];
  };

  src = fetchurl {
    url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/obsidian-${version}${extension}";
    inherit sha256;
  };

  sha256 = rec {
    x86_64-linux = "v3Zm5y8V1KyWDQeJxhryBojz56OTT7gfT+pLGDUD4zs=";
    x86_64-darwin = "m/81uuDhMJJ1tHTUPww+xNdwsaYCOmeNtbjdwMAwhBU=";
    aarch64-darwin = x86_64-darwin;
  }.${system};

  extension = rec {
    x86_64-linux = ".tar.gz";
    x86_64-darwin = "-universal.dmg";
    aarch64-darwin = x86_64-darwin;
  }.${system};

  linux = stdenv.mkDerivation rec {
    icon = fetchurl {
      url = "https://forum.obsidian.md/uploads/default/original/1X/bf119bd48f748f4fd2d65f2d1bb05d3c806883b5.png";
      sha256 = "18ylnbvxr6k4x44c4i1d55wxy2dq4fdppp43a4wl6h6zar0sc9s2";
    };

    desktopItem = makeDesktopItem {
      name = "obsidian";
      desktopName = "Obsidian";
      comment = "Knowledge base";
      icon = "obsidian";
      exec = "obsidian";
      categories = [ "Office" ];
    };

    inherit pname version src;
    meta.platforms = [ "x86_64-linux" ];
    nativeBuildInputs = [ makeWrapper graphicsmagick ];
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      makeWrapper ${electron_16}/bin/electron $out/bin/obsidian \
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

    passthru.updateScript = writeScript "updater" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq common-updater-scripts
      set -eu -o pipefail
      latestVersion="$(curl -sS https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/desktop-releases.json | jq -r '.latestVersion')"
      update-source-version obsidian "$latestVersion"
    '';
  };

  darwin = stdenv.mkDerivation rec {
    appname = "Obsidian";
    inherit pname version src;
    meta.platforms = [ "x86_64-darwin" "aarch64-darwin" ];
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
