{ stdenv, lib, fetchurl, copyDesktopItems, makeDesktopItem, makeWrapper
, writeShellScriptBin, electron }:

let
  # This script is mandatory to make this application work
  # without user intervention. The reasoning is specified below:
  # https://github.com/NixOS/nixpkgs/issues/148152#issuecomment-983773905
  exec_script = writeShellScriptBin "exec_script" ''
    #!/usr/bin/env bash

    set -euo pipefail

    CONFIG_PATH="$HOME/.config/Abricotine"

    if [ ! -d "$CONFIG_PATH" ]; then
        SOURCE_SUBPATH="/opt/abricotine/resources/app.asar.unpacked/default"
        mkdir -p "$CONFIG_PATH/app"
        cp -R "$1$SOURCE_SUBPATH/dict" "$CONFIG_PATH/app/dict"
        cp -R "$1$SOURCE_SUBPATH/lang" "$CONFIG_PATH/app/lang"
        cp -R "$1$SOURCE_SUBPATH/templates" "$CONFIG_PATH/app/templates"
        cp -R "$1$SOURCE_SUBPATH/themes" "$CONFIG_PATH/app/themes"
        chmod -R u+w "$CONFIG_PATH/app/"
    fi
  '';

in stdenv.mkDerivation rec {
  pname = "abricotine";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/brrd/abricotine/releases/download/${version}/abricotine-${version}-linux-x64.tar.gz";
    sha256 = "sha256-87vudcf1vAnkRVRoaVguHHoJwMJpsiM5+c/3m9lIxRc=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "abricotine";
      icon = "abricotine";
      comment = meta.description;
      desktopName = "Abricotine";
      genericName = "Markdown Editor";
    })
  ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/abricotine $out/share/pixmaps
    cp -r . $out/opt/abricotine

    # Icons dir does not follow typical structure
    cp $out/opt/abricotine/icons/abricotine.svg $out/share/pixmaps/

    makeWrapper ${electron}/bin/electron $out/bin/abricotine \
      --run "${exec_script}/bin/exec_script $out" \
      --add-flags $out/opt/abricotine/resources/app.asar

    runHook postInstall
  '';

  meta = with lib; {
    description = "Markdown editor with inline preview";
    homepage = "https://abricotine.brrd.fr/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
