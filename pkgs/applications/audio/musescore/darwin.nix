{ stdenv, lib, fetchurl, undmg }:

let
  versionComponents = [ "4" "1" "0" ];
  appName = "MuseScore ${builtins.head versionComponents}";
  ref = "231921401";
in

stdenv.mkDerivation rec {
  pname = "musescore-darwin";
  version = lib.concatStringsSep "." versionComponents;

  # The disk image contains the .app and a symlink to /Applications.
  sourceRoot = "${appName}.app";

  src = fetchurl {
    url =  "https://github.com/musescore/MuseScore/releases/download/v${version}/MuseScore-${version}.${ref}.dmg";
    hash = "sha256-uyhGWcKSELz7WiWxZPoEJ+L5VvnHZFaU6aQtwhmmhHk=";
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
