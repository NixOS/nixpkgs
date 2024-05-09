{
  lib,
  stdenv,
  undmg,
  fetchurl,
  makeDesktopItem,
  appimageTools,
}:
let
  pname = "creality-print";
  version = if stdenv.isLinux then "4.3.7.6627" else "5.1.1.9490";
  versionChangelog = lib.concatStringsSep "." (lib.take 3 (lib.splitString "." version));

  src = fetchurl {
    url =
      let
        basePart = "https://file2-cdn.creality.com/file";
        fileHash =
          if stdenv.isLinux then "05a4538e0c7222ce547eb8d58ef0251e" else "21e5a2a7b4468f713ce0f2147c7f0115";
        suffix = if stdenv.isLinux then "x86_64-Release.AppImage" else "macx-x86_64-Release.dmg";
      in
      "${basePart}/${fileHash}/Creality_Print-v${version}-${suffix}";

    hash =
      if stdenv.isLinux then
        "sha256-WUsL7UbxSY94H4F1Ww8vLsfRyeg2/DZ+V4B6eH3M6+M="
      else
        "sha256-yE/C1qKwlaGgjbHZI8+RkuXaqYJbYpKOzySu6/KVzr4=";
  };

  linuxDerivation = appimageTools.wrapType2 {
    inherit pname version src;
    desktopItems = [
      (makeDesktopItem {
        name = "creality-print";
        exec = "creality-print";
        terminal = false;
        desktopName = "Creality Print";
        comment = meta.description;
        categories = [ "Utility" ];
      })
    ];
    inherit meta;
  };

  darwinDerivation = stdenv.mkDerivation {
    inherit pname version src;
    nativeBuildInputs = [ undmg ];
    sourceRoot = "Creality Print.app";
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/Applications/Creality Print.app"
      cp -R . "$out/Applications/Creality Print.app"
      runHook postInstall
    '';
    inherit meta;
  };

  meta = {
    changelog = "https://github.com/CrealityOfficial/CrealityPrint/blob/v${versionChangelog}/README.md";
    description = "Creality 3D Printing Slicing Software";
    mainProgram = "creality-print";
    homepage = "https://www.creality.com";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ afresquet ];
  };
in
if stdenv.isLinux then linuxDerivation else darwinDerivation
