{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  testers,
  gitUpdater,
  doxygen,
  texliveBasic,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ilo";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "Fraunhofer-IIS";
    repo = "ilo";
    tag = "r${finalAttrs.version}";
    hash = "sha256-az7fnZG8js+vGVtECcwcHu2JuvME1vJoQlKbkAwgO9w=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  patches = [
    # https://github.com/Fraunhofer-IIS/ilo/pull/2
    ./pkg-config.patch
    # https://github.com/Fraunhofer-IIS/ilo/pull/1
    ./install-doc.patch
  ];

  nativeBuildInputs = [
    cmake
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
    (lib.cmakeBool "ilo_BUILD_DOC" true)
  ];

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { rev-prefix = "r"; };
  };

  meta = {
    description = "Collection of helpful datatypes and algorithms for MPEG-H software";
    homepage = "https://github.com/Fraunhofer-IIS/ilo";
    license = lib.licenses.fraunhofer-fdk;
    maintainers = [ lib.maintainers.jopejoe1 ];
    pkgConfigModules = [ "ilo" ];
  };
})
