{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  testers,
  gitUpdater,
  doxygen,
  pkg-config,
  texliveBasic,
  writableTmpDirAsHomeHook,
  ilo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mmtisobmff";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "Fraunhofer-IIS";
    repo = "mmtisobmff";
    tag = "r${finalAttrs.version}";
    hash = "sha256-2W5H4GfJu2tOOWp8x1z1DJe5yJ3htc0o8nIeEdwiMd4=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  patches = [
    # https://github.com/Fraunhofer-IIS/mmtisobmff/pull/4
    ./pkg-config.patch
    # https://github.com/Fraunhofer-IIS/mmtisobmff/pull/5
    ./install-doc.patch
    # https://github.com/Fraunhofer-IIS/mmtisobmff/pull/6
    ./demo.patch
  ];

  buildInputs = [
    ilo
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
    (lib.cmakeBool "mmtisobmff_BUILD_BINARIES" true)
    (lib.cmakeBool "mmtisobmff_BUILD_DOC" true)
    (lib.cmakeBool "USE_PKGCONFIG_DEPS" true)
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
    description = "ISOBMFF reader and writer library with MPEG-H 3D Audio support";
    homepage = "https://github.com/Fraunhofer-IIS/mmtisobmff";
    license = lib.licenses.fraunhofer-fdk;
    maintainers = [ lib.maintainers.jopejoe1 ];
    pkgConfigModules = [ "mmtisobmff" ];
  };
})
