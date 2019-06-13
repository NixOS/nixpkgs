{ stdenv, fetchFromGitHub, qt4, qmake4Hook }:

stdenv.mkDerivation rec {
  name = "arora-${version}";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "Arora";
    repo = "arora";
    rev = version;
    sha256 = "0wmivgx3mw51rghi6q8fgivpkqc98z2mqmllf7c98ln0wd8rkf3c";
  };

  buildInputs = [ qt4 ];
  nativeBuildInputs = [ qmake4Hook ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = qt4.meta.platforms;
    maintainers = [ maintainers.phreedom ];
    description = "A cross-platform Qt4 Webkit browser";
    homepage = https://github.com/Arora/arora;
    license = with licenses; [ gpl2 gpl3 ];
  };
}
