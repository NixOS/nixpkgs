{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  glib,
  pkg-config,
  validatePkgConfig,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libvisual";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "Libvisual";
    repo = "libvisual";
    rev = "libvisual-${finalAttrs.version}";
    hash = "sha256-bDnpQODXB2Z6hezVoh7c6cklp6qpyDzVBAnwZD8Gros=";
  };

  sourceRoot = "${finalAttrs.src.name}/libvisual";

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
    validatePkgConfig
  ];
  buildInputs = [ glib ];

  configureFlags =
    [
      (lib.enableFeature false "lv-tool")
      (lib.enableFeature false "examples")
    ]
    ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      "ac_cv_func_malloc_0_nonnull=yes"
      "ac_cv_func_realloc_0_nonnull=yes"
    ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Abstraction library for audio visualisations";
    homepage = "http://libvisual.org/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
    pkgConfigModules = [ "libvisual-0.4" ];
  };
})
