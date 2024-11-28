{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  libogg,
  libvorbis,
  pkg-config,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtheora";
  version = "1.1.1";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/theora/libtheora-${finalAttrs.version}.tar.gz";
    hash = "sha256-QJUpVsR4EZKNHnkizaO8H0J+t1aAw8NySckelJBUkWs=";
  };

  patches = [
    # fix error in autoconf scripts
    (fetchpatch {
      url = "https://github.com/xiph/theora/commit/28cc6dbd9b2a141df94f60993256a5fca368fa54.diff";
      hash = "sha256-M/UULkiklvEay7LyOuCamxWCSvt37QSMzHOsAAnOWJo=";
    })
  ] ++ lib.optionals stdenv.hostPlatform.isMinGW [ ./mingw-remove-export.patch ];

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
    description = "Library for Theora, a free and open video compression format";
    homepage = "https://www.theora.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ getchoo ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
