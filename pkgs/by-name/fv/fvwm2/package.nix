{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  cairo,
  fontconfig,
  freetype,
  fribidi,
  libxcursor,
  libxft,
  libxinerama,
  libxpm,
  libxt,
  libpng,
  librsvg,
  libstroke,
  libxslt,
  perl,
  pkg-config,
  python3Packages,
  readline,
  enableGestures ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fvwm";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "fvwmorg";
    repo = "fvwm";
    tag = finalAttrs.version;
    hash = "sha256-KcuX8las1n8UUE/BOHj7WOeZjva5hxgpFHtATMUk3bg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3Packages.wrapPython
  ];

  buildInputs = [
    cairo
    fontconfig
    freetype
    fribidi
    libxcursor
    libxft
    libxinerama
    libxpm
    libxt
    libpng
    librsvg
    libxslt
    perl
    python3Packages.python
    readline
  ]
  ++ lib.optional enableGestures libstroke;

  pythonPath = [
    python3Packages.pyxdg
  ];

  configureFlags = [
    "--enable-mandoc"
    "--disable-htmldoc"
  ];

  # Fix build on GCC 14 (see https://github.com/fvwmorg/fvwm/pull/100)
  # Will never be accepted as an upstream patch as FVWM2 is EOL
  env.NIX_CFLAGS_COMPILE = "-Wno-error=int-conversion -Wno-error=incompatible-pointer-types";

  postFixup = ''
    wrapPythonPrograms
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "http://fvwm.org";
    changelog = "https://github.com/fvwmorg/fvwm/releases/tag/${finalAttrs.src.rev}";
    description = "Multiple large virtual desktop window manager";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ edanaher ];
  };
})
