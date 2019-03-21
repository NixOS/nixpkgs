{ stdenv, fetchFromGitHub, pkgconfig, which, qtbase, qtsvg, qttools, qtwebkit}:

let
  version = "1.4.8";
in stdenv.mkDerivation {
  name = "notepadqq-${version}";
  src = fetchFromGitHub {
    owner = "notepadqq";
    repo = "notepadqq";
    rev = "v${version}";
    sha256 = "0lbv4s7ng31dkznzbkmp2cvkqglmfj6lv4mbg3r410fif2nrva7k";
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

  enableParallelBuilding = true;

  meta = {
    homepage = https://notepadqq.com/;
    description = "Notepad++-like editor for the Linux desktop";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ rszibele ];
  };
}
