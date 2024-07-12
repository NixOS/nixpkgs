{ stdenv, lib, fetchFromGitHub, libX11, libXft, freetype, patches ? [ ],
  extraLibs ? [ ] }:

stdenv.mkDerivation rec {
  pname = "herbe";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dudik";
    repo = pname;
    rev = version;
    sha256 = "0358i5jmmlsvy2j85ij7m1k4ar2jr5lsv7y1c58dlf9710h186cv";
  };

  inherit patches;

  postPatch = ''
    sed -i 's_/usr/include/freetype2_${freetype.dev}/include/freetype2_' Makefile
  '';

  buildInputs = [ libX11 libXft freetype ] ++ extraLibs;

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Daemon-less notifications without D-Bus";
    homepage = "https://github.com/dudik/herbe";
    license = licenses.mit;
    # NOTE: Could also work on 'unix'.
    platforms = platforms.linux;
    maintainers = with maintainers; [ wishfort36 ];
    mainProgram = "herbe";
  };
}
