{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  freetype,
  fribidi,
  imlib2,
  libX11,
  libXext,
  libXft,
  libXinerama,
  libXpm,
  libXrandr,
  libXrender,
  pkg-config,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hackedbox";
  version = "0.8.5.1";

  src = fetchFromGitHub {
    owner = "museoa";
    repo = "hackedbox";
    rev = finalAttrs.version;
    hash = "sha256-hxfbEj7UxQ19xhetmdi0iyK6ceLUfUvAAyyTbNivlLQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  CXXFLAGS = "-std=c++98";

  buildInputs = [
    freetype
    fribidi
    imlib2
    libX11
    libXext
    libXft
    libXinerama
    libXpm
    libXrandr
    libXrender
    xorgproto
  ];

  configureFlags = [
    "--x-includes=${libX11.dev}/include"
    "--x-libraries=${libX11.out}/lib"
  ];

  meta = with lib; {
    description = "A bastard hacked offspring of Blackbox";
    homepage = "https://github.com/museoa/hackedbox/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (libX11.meta) platforms;
  };
})
