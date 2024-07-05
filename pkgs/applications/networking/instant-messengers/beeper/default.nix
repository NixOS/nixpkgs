{ lib
, stdenvNoCC
, fetchurl
, appimageTools
, makeWrapper
, writeShellApplication
, curl
, yq
, common-updater-scripts
}:
let
  pname = "beeper";
  version = "3.106.2";
  src = fetchurl {
    url = "https://download.todesktop.com/2003241lzgn20jd/beeper-3.106.2-build-240604xwl5q01pr-x86_64.AppImage";
    hash = "sha256-WbAWJJzk58UVmRN3RHmU/V6zPiLWAb7m7hns4gmP55M=";
  };
  appimage = appimageTools.wrapType2 {
    inherit version pname src;
    extraPkgs = pkgs: [ pkgs.libsecret ];
  };
  appimageContents = appimageTools.extractType2 {
    inherit version pname src;
  };
in
stdenvNoCC.mkDerivation rec {
  inherit pname version;

  src = appimage;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -r bin $out/bin

    mkdir -p $out/share/${pname}
    cp -a ${appimageContents}/locales $out/share/${pname}
    cp -a ${appimageContents}/resources $out/share/${pname}
    cp -a ${appimageContents}/usr/share/icons $out/share/
    install -Dm 644 ${appimageContents}/${pname}.desktop -t $out/share/applications/

    substituteInPlace $out/share/applications/${pname}.desktop --replace "AppRun" "${pname}"

    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}} --no-update"

    runHook postInstall
  '';

  passthru = {
    updateScript = lib.getExe (writeShellApplication {
      name = "update-beeper";
      runtimeInputs = [ curl yq common-updater-scripts ];
      text = ''
        set -o errexit
        latestLinux="$(curl -s https://download.todesktop.com/2003241lzgn20jd/latest-linux.yml)"
        version="$(echo "$latestLinux" | yq -r .version)"
        filename="$(echo "$latestLinux" | yq -r '.files[] | .url | select(. | endswith(".AppImage"))')"
        update-source-version beeper "$version" "" "https://download.todesktop.com/2003241lzgn20jd/$filename" --source-key=src.src
      '';
    });
  };

  meta = with lib; {
    description = "Universal chat app";
    longDescription = ''
      Beeper is a universal chat app. With Beeper, you can send
      and receive messages to friends, family and colleagues on
      many different chat networks.
    '';
    homepage = "https://beeper.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ jshcmpbll mjm edmundmiller ];
    platforms = [ "x86_64-linux" ];
  };
}
