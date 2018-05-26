{ stdenv, fetchgit, pkgconfig, which, qtbase, qtsvg, qttools, qtwebkit}:

let
  version = "1.2.0";
in stdenv.mkDerivation {
  name = "notepadqq-${version}";
  src = fetchgit {
    url = "https://github.com/notepadqq/notepadqq.git";
    rev = "ab074d30e02d49e0fe6957c1523e7fed239aff7d";
    sha256 = "0j8vqsdw314qpk5lrgccm9n7gbyr14ac3s65sl1qn87pxhrz1hpg";
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
    homepage = http://notepadqq.altervista.org/;
    description = "Notepad++-like editor for the Linux desktop";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ rszibele ];
  };
}
