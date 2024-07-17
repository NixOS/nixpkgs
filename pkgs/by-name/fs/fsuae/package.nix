{
  lib,
  SDL2,
  autoreconfHook,
  fetchFromGitHub,
  freetype,
  gettext,
  glib,
  gtk2,
  libGL,
  libGLU,
  libmpeg2,
  lua,
  openal,
  pkg-config,
  strip-nondeterminism,
  stdenv,
  zip,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fs-uae";
  version = "3.1.66";

  src = fetchFromGitHub {
    owner = "FrodeSolheim";
    repo = "fs-uae";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zPVRPazelmNaxcoCStB0j9b9qwQDTgv3O7Bg3VlW9ys=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    strip-nondeterminism
    zip
  ];

  buildInputs = [
    SDL2
    freetype
    gettext
    glib
    gtk2
    libGL
    libGLU
    libmpeg2
    lua
    openal
    zlib
  ];

  strictDeps = true;

  # Make sure that the build timestamp is not included in the archive
  postFixup = ''
    strip-nondeterminism --type zip $out/share/fs-uae/fs-uae.dat
  '';

  meta = {
    homepage = "https://fs-uae.net";
    description = "An accurate, customizable Amiga Emulator";
    longDescription = ''
      FS-UAE integrates the most accurate Amiga emulation code available from
      WinUAE. FS-UAE emulates A500, A500+, A600, A1200, A1000, A3000 and A4000
      models, but you can tweak the hardware configuration and create customized
      Amigas.
    '';
    license = lib.licenses.gpl2Plus;
    mainProgram = "fs-uae";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = with lib.systems.inspect; patternLogicalAnd patterns.isx86 patterns.isLinux;
  };
})
