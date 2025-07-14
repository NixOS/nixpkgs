{
  lib,
  stdenv,
  fetchurl,
  undmg,
  runCommand,
}:

let
  self = stdenv.mkDerivation rec {
    pname = "kdeconnect-macos";
    version = "master-5196-macos";

    src = fetchurl ({
      url = "https://cdn.kde.org/ci-builds/network/kdeconnect-kde/master/macos-arm64/kdeconnect-kde-${version}-clang-arm64.dmg";
      hash = "sha256-q4hbWJJNYsF2YjGguTdb+gwg7FxUpZ9LHlriWNfCKpM="; # This will need to be updated with actual hash
    });

    sourceRoot = ".";

    nativeBuildInputs = [ undmg ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r *.app $out/Applications/

      runHook postInstall
    '';

    meta = with lib; {
      description = "Multi-platform app that allows your devices to communicate (macOS version)";
      longDescription = ''
        KDE Connect is a multi-platform application that allows your devices to
        communicate. This is the official macOS version built from KDE's CI system.

        Features:
        - Share files and links between devices
        - Remote input: Use your phone as a touchpad and keyboard
        - Multimedia remote control
        - WiFi connection: No USB wire or Bluetooth needed
        - RSA 2048-bit encryption
      '';
      homepage = "https://kdeconnect.kde.org/";
      changelog = "https://kde.org/announcements/gear/${version} /";
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ ojii3 ];
      platforms = [ "aarch64-darwin" ];
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    };
  };
in
self
