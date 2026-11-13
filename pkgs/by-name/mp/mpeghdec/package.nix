{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  gitUpdater,
  cmake,
  pkg-config,
  doxygen,
  writableTmpDirAsHomeHook,
  texliveBasic,
  ilo,
  mmtisobmff,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpeghdec";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "Fraunhofer-IIS";
    repo = "mpeghdec";
    tag = "r${finalAttrs.version}";
    hash = "sha256-P+xPaigy9YkXCyk9iIMdJzkXVipUHM68cLr4nepb2yc=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  patches = [
    # https://github.com/Fraunhofer-IIS/mpeghdec/pull/19
    ./pkg-config.patch
    # https://github.com/Fraunhofer-IIS/mpeghdec/pull/20
    ./install-doc.patch
    # https://github.com/Fraunhofer-IIS/mpeghdec/pull/21
    ./install-bin.patch
  ];

  buildInputs = [
    ilo
    mmtisobmff
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    doxygen
    writableTmpDirAsHomeHook
    (texliveBasic.withPackages (ps: [
      ps.float
      ps.varwidth
      ps.xcolor
      ps.xltabular
      ps.ltablex
      ps.tabularray
      ps.ninecolors
      ps.fancyvrb
      ps.multirow
      ps.hanging
      ps.adjustbox
      ps.stackengine
      ps.enumitem
      ps.alphalph
      ps.ulem
      ps.wasysym
      ps.changepage
      ps.tocloft
      ps.newunicodechar
      ps.caption
      ps.etoc
      ps.helvetic
      ps.wasy
      ps.courier
    ]))
  ];

  cmakeFlags = [
    (lib.cmakeBool "mpeghdec_BUILD_BINARIES" true)
    (lib.cmakeBool "mpeghdec_BUILD_DOC" true)
    (lib.cmakeBool "USE_PKGCONFIG_DEPS" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  outputs = [
    "out"
    "dev"
    "doc"
    "bin"
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { rev-prefix = "r"; };
  };

  meta = {
    description = "C/C++ implementation of the MPEG-H Audio standard as defined in ISO/IEC 23008-3:2022";
    homepage = "https://github.com/Fraunhofer-IIS/mpeghdec";
    license = lib.licenses.fraunhofer-fdk;
    maintainers = [ lib.maintainers.jopejoe1 ];
    pkgConfigModules = [ "mpeghdec" ];
  };
})
