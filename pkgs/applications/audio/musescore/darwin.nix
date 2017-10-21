{ stdenv, fetchurl, undmg }:

let
  major = "2";
  minor = "0.3";
  patch = "1";
  appName = "MuseScore ${major}";
in

stdenv.mkDerivation rec {
  name = "musescore-darwin-${version}";
  version = "${major}.${minor}.${patch}";

  src = fetchurl {
    url =  "ftp://ftp.osuosl.org/pub/musescore/releases/MuseScore-${major}.${minor}/MuseScore-${version}.dmg";
    sha256 = "0a9v2nc7sx2az7xpd9i7b84m7xk9zcydfpis5fj334r5yqds4rm1";
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
