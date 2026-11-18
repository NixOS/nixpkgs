{
  stdenv,
  lib,
  fetchFromGitHub,
  libx11,
  libxft,
  freetype,
  patches ? [ ],
  extraLibs ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "herbe";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dudik";
    repo = "herbe";
    rev = finalAttrs.version;
    sha256 = "0358i5jmmlsvy2j85ij7m1k4ar2jr5lsv7y1c58dlf9710h186cv";
  };

  inherit patches;

  postPatch = ''
    sed -i 's_/usr/include/freetype2_${freetype.dev}/include/freetype2_' Makefile
  '';

  buildInputs = [
    libx11
    libxft
    freetype
  ]
  ++ extraLibs;

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Daemon-less notifications without D-Bus";
    homepage = "https://github.com/dudik/herbe";
    license = lib.licenses.mit;
    # NOTE: Could also work on 'unix'.
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ wishfort36 ];
    mainProgram = "herbe";
  };
})
