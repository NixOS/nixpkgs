{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  imlib2,
  libx11,
  libxinerama,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hsetroot";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "himdel";
    repo = "hsetroot";
    rev = finalAttrs.version;
    hash = "sha256-Qpy8K0wCqCWab1roFnZ4HGdUtCGpYDW/rB+R2iksc8k=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    imlib2
    libx11
    libxinerama
  ];

  postPatch = lib.optionalString (!stdenv.cc.isGNU) ''
    sed -i -e '/--no-as-needed/d' Makefile
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p "$out/bin"
  '';

  meta = {
    description = "Allows you to compose wallpapers ('root pixmaps') for X";
    homepage = "https://github.com/himdel/hsetroot";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
