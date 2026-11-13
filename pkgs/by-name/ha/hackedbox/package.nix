{
  lib,
  stdenv,
  fetchFromCodeberg,
  autoreconfHook,
  freetype,
  fribidi,
  imlib2,
  libx11,
  libxext,
  libxft,
  libxinerama,
  libxpm,
  libxrandr,
  libxrender,
  pkg-config,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hackedbox";
  version = "0.8.5.1";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "museoa";
    repo = "hackedbox";
    tag = finalAttrs.version;
    hash = "sha256-hxfbEj7UxQ19xhetmdi0iyK6ceLUfUvAAyyTbNivlLQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  env.CXXFLAGS = "-std=c++98";

  buildInputs = [
    freetype
    fribidi
    imlib2
    libx11
    libxext
    libxft
    libxinerama
    libxpm
    libxrandr
    libxrender
    xorgproto
  ];

  configureFlags = [
    "--x-includes=${libx11.dev}/include"
    "--x-libraries=${libx11.out}/lib"
  ];

  meta = {
    description = "Bastard hacked offspring of Blackbox";
    homepage = "https://codeberg.org/museoa/hackedbox";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    inherit (libx11.meta) platforms;
  };
})
