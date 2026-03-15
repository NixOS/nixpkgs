{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libogg,
  libvorbis,
  pkg-config,
  perl,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtheora";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "xiph";
    repo = "theora";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kzZh4V6wZX9MetDutuqjRenmdpy4PHaRU9MgtIwPpiU=";
  };

  patches = lib.optionals stdenv.hostPlatform.isMinGW [ ./mingw-remove-export.patch ];

  postPatch = lib.optionalString stdenv.hostPlatform.isAarch32 ''
    patchShebangs lib/arm/arm2gnu.pl
  '';

  configureFlags = [ "--disable-examples" ];

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];
  outputDoc = "devdoc";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    validatePkgConfig
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch32 [
    # Needed to run lib/arm/arm2gnu.pl for ARM assembly optimizations
    perl
  ];

  propagatedBuildInputs = [
    libogg
    libvorbis
  ];

  strictDeps = true;

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [
        "theora"
        "theoradec"
        "theoraenc"
      ];
    };
  };

  meta = {
    changelog = "https://gitlab.xiph.org/xiph/theora/-/releases/v${finalAttrs.version}";
    description = "Library for Theora, a free and open video compression format";
    homepage = "https://www.theora.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ getchoo ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
