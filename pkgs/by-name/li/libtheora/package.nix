{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  libogg,
  libvorbis,
  pkg-config,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtheora";
  version = "1.2.0";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/theora/libtheora-${finalAttrs.version}.tar.gz";
    hash = "sha256-J5MnM5kDtUTCipKurafQ3P0Dl7WcLzaMxpisVvUVkG4=";
  };

  patches = lib.optionals stdenv.hostPlatform.isMinGW [ ./mingw-remove-export.patch ];

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
  ];

  propagatedBuildInputs = [
    libogg
    libvorbis
  ];

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
