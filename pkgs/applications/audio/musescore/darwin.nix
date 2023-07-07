{ stdenv, lib, fetchurl, undmg }:

let
  versionComponents = [ "4" "0" "1" ];
  appName = "MuseScore ${builtins.head versionComponents}";
  ref = "230121751";
in

stdenv.mkDerivation rec {
  pname = "musescore-darwin";
  version = lib.concatStringsSep "." versionComponents;

  # The disk image contains the .app and a symlink to /Applications.
  sourceRoot = "${appName}.app";

  src = fetchurl {
    url =  "https://github.com/musescore/MuseScore/releases/download/v${version}/MuseScore-${version}.${ref}.dmg";
    hash = "sha256-tkIEV+tCS0SYh2TlC70/zEBUEOSg//EaSKDGA7kH/vo=";
  };

  buildInputs = [ undmg ];
  installPhase = ''
    mkdir -p "$out/Applications/${appName}.app"
    cp -R . "$out/Applications/${appName}.app"
    chmod a+x "$out/Applications/${appName}.app/Contents/MacOS/mscore"
  '';

  meta = with lib; {
    description = "Music notation and composition software";
    homepage = "https://musescore.org/";
    license = licenses.gpl3Only;
    platforms = platforms.darwin;
    maintainers = [];
  };
}
