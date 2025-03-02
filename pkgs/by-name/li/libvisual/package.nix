{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL_compat,
  autoreconfHook,
  autoconf-archive,
  glib,
  pkgconf,
  validatePkgConfig,
  testers,
  fullVariant ? false,
  withLvTool ? fullVariant,
  withExamples ? fullVariant,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libvisual" + lib.optionalString fullVariant "-full";
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
    pkgconf
    validatePkgConfig
  ];
  buildInputs = [ glib ] ++ lib.optional (withLvTool || withExamples) SDL_compat;

  preConfigure = ''
    PKG_CONFIG=pkgconf
  '';

  configureFlags =
    [
      (lib.enableFeature withLvTool "lv-tool")
      (lib.enableFeature withExamples "examples")
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
    platforms = lib.platforms.linux;
    pkgConfigModules = [ "libvisual-0.4" ];
  } // lib.attrsets.optionalAttrs withLvTool { mainProgram = "lv-tool-0.4"; };
})
