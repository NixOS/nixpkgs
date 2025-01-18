{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  SDL,
  autoreconfHook,
  autoconf-archive,
  glib,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libvisual";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "Libvisual";
    repo = "libvisual";
    rev = "libvisual-${version}";
    hash = "sha256-bDnpQODXB2Z6hezVoh7c6cklp6qpyDzVBAnwZD8Gros=";
  };

  sourceRoot = "${src.name}/libvisual";

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];
  buildInputs = [
    SDL
    glib
  ];

  configureFlags =
    lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      # Remove when 0.5.x is published.
      "--disable-lv-tool"
    ]
    ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      "ac_cv_func_malloc_0_nonnull=yes"
      "ac_cv_func_realloc_0_nonnull=yes"
    ];

  meta = with lib; {
    description = "Abstraction library for audio visualisations";
    homepage = "https://sourceforge.net/projects/libvisual/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
