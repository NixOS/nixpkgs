{ stdenv, lib, fetchurl, undmg }:

let
  versionComponents = [ "2" "1" ];
  appName = "MuseScore ${builtins.head versionComponents}";
in

with lib;

stdenv.mkDerivation rec {
  pname = "musescore-darwin";
  version = concatStringsSep "." versionComponents;

  src = fetchurl {
    url =  "ftp://ftp.osuosl.org/pub/musescore/releases/MuseScore-${concatStringsSep "." (take 3 versionComponents)}/MuseScore-${version}.dmg";
    sha256 = "19xkaxlkbrhvfip6n3iw6q7463ngr6y5gfisrpjqg2xl2igyl795";
  };

  buildInputs = [ undmg ];
  installPhase = ''
    mkdir -p "$out/Applications/${appName}.app"
    cp -R . "$out/Applications/${appName}.app"
    chmod a+x "$out/Applications/${appName}.app/Contents/MacOS/mscore"
  '';

  meta = with stdenv.lib; {
    description = "Music notation and composition software";
    homepage = https://musescore.org/;
    license = licenses.gpl2;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ yurrriq ];
    repositories.git = https://github.com/musescore/MuseScore;
  };
}
