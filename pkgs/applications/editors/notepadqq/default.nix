{ mkDerivation, lib, fetchFromGitHub, pkgconfig, which, qtbase, qtsvg, qttools, qtwebkit }:

mkDerivation rec {
  pname = "notepadqq";
  version = "1.4.8";

  src = fetchFromGitHub {
    owner = "notepadqq";
    repo = "notepadqq";
    rev = "v${version}";
    sha256 = "0lbv4s7ng31dkznzbkmp2cvkqglmfj6lv4mbg3r410fif2nrva7k";
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

  dontWrapQtApps = true;

  preFixup = ''
    wrapQtApp $out/bin/notepadqq
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://notepadqq.com/";
    description = "Notepad++-like editor for the Linux desktop";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.rszibele ];
  };
}
