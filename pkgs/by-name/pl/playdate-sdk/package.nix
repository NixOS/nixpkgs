{
  autoPatchelfHook,
  copyDesktopItems,
  fetchurl,
  lib,
  makeDesktopItem,
  makeWrapper,
  pkgs,
  stdenv,
}:

let
  version = "2.5.0";
in

stdenv.mkDerivation rec {
  pname = "playdate-sdk";
  inherit version;

  src = fetchurl {
    url = "https://download.panic.com/playdate_sdk/Linux/PlaydateSDK-${version}.tar.gz";
    sha256 = "d5bee3ee590dd7a60ee04516c993d9f8f3c2f526b7005a0de5cf3802b4c65e89";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = with pkgs; [
    webkitgtk
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/playdate-sdk
    cp -r * $out/share/playdate-sdk

    #### pdc
    install -Dm755 $out/share/playdate-sdk/bin/pdc $out/bin/pdc

    #### pdutil
    install -Dm755 $out/share/playdate-sdk/bin/pdutil $out/bin/pdutil

    #### PlaydateSimulator
    # TODO: make simulator also work with auto patch elf instead of steam-run
    makeWrapper ${pkgs.steam-run}/bin/steam-run $out/bin/PlaydateSimulator \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pkgs.webkitgtk ]} \
      --append-flags $out/share/playdate-sdk/bin/PlaydateSimulator

    #### C API includes
    mkdir -p $out/include
    cp -r $out/share/playdate-sdk/C_API/pd_api $out/include/pd_api
    cp $out/share/playdate-sdk/C_API/pd_api.h $out/include/pd_api.h

    #### udev rules
    mkdir -p $out/etc/udev/rules.d
    cp $out/share/playdate-sdk/Resources/50-playdate.rules $out/etc/udev/rules.d/

    #### icons
    install -Dm644 $out/share/playdate-sdk/Resources/date.play.simulator.svg $out/share/icons/hicolor/scalable/apps/PlaydateSimulator.svg

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "PlaydateSimulator";
      exec = "PlaydateSimulator %u";
      icon = "PlaydateSimulator";
      desktopName = "Playdate Simulator";
      comment = "A toolset for developing games on the Playdate handheld console";
      categories = [ "Development" ];
      startupWMClass = "PlaydateSimulator";
      mimeTypes = ["application/x-playdate-game" "x-scheme-handler/playdate-simulator"];
    })
  ];

  meta = with lib; {
    description = "PlayDate SDK";
    homepage = "https://play.date";
    license = licenses.unfree;
    maintainers = with maintainers; [ atomicptr ];
    platforms = ["x86_64-linux"];
  };
}
