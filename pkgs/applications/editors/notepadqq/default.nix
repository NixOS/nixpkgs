{ stdenv, fetchgit, pkgconfig, which, qtbase, qtsvg, qttools, qtwebkit }:

let
  version = "0.53.0";
in stdenv.mkDerivation {
  name = "notepadqq-${version}";
  src = fetchgit {
    url = "https://github.com/notepadqq/notepadqq.git";
    rev = "3b0751277fb268ec72b466b37d0f0977c536bc1b";
    sha256 = "0hw94mn2xg2r58afvz1xg990jinv9aa33942zgwq54qwj61r93hi";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkgconfig which qttools
  ];

  buildInputs = [
    qtbase qtsvg qtwebkit
  ];

  preConfigure = ''
    export LRELEASE="lrelease"
  '';

  meta = {
    homepage = "http://notepadqq.altervista.org/";
    description = "Notepad++-like editor for the Linux desktop";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ rszibele ];
  };
}
