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
  version = if stdenv.isLinux then "4.3.7.6627" else "4.3.8.6984";
  versionChangelog = lib.concatStringsSep "." (lib.take 3 (lib.splitString "." version));

  src = fetchurl {
    url =
      let
        basePart = "https://file2-cdn.creality.com/file";
        fileHash =
          if stdenv.isLinux then "05a4538e0c7222ce547eb8d58ef0251e" else "8dcd085c64cc389dacd21cd851593d42";
        suffix = if stdenv.isLinux then "x86_64-Release.AppImage" else "macx-Release.dmg";
      in
      "${basePart}/${fileHash}/Creality_Print-v${version}-${suffix}";

    hash =
      if stdenv.isLinux then
        "sha256-WUsL7UbxSY94H4F1Ww8vLsfRyeg2/DZ+V4B6eH3M6+M="
      else
        "sha256-0v6/aNzgEf+jF4N+XmPWcpzdJUiUujQSmlcRiGm1z5E=";
  };

  linuxDerivation = appimageTools.wrapType2 {
    inherit pname version src;
    desktopItems = [
      (makeDesktopItem {
        name = pname;
        exec = pname;
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
    homepage = "https://www.creality.com";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ afresquet ];
  };
in
if stdenv.isLinux then linuxDerivation else darwinDerivation
