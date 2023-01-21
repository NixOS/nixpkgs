{ stdenv, lib, fetchurl, undmg }:

let
  versionComponents = [ "3" "6" "2" "548020600" ];
  appName = "MuseScore ${builtins.head versionComponents}";
in

stdenv.mkDerivation rec {
  pname = "musescore-darwin";
  version = lib.concatStringsSep "." versionComponents;

  # The disk image contains the .app and a symlink to /Applications.
  sourceRoot = "${appName}.app";

  src = fetchurl {
    url = "https://github.com/musescore/MuseScore/releases/download/v${lib.concatStringsSep "." (lib.take 3 versionComponents)}/MuseScore-${version}.dmg";
    sha256 = "sha256-lHckfhTTrDzaGwlbnZ5w0O1gMPbRmrmgATIGMY517l0=";
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
