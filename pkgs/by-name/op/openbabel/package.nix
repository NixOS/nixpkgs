{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  perl,
  zlib,
  libxml2,
  eigen,
  python3,
  cairo,
  pkg-config,
  swig,
  rapidjson,
  boost,
  maeparser,
  coordgenlibs,
  ctestCheckHook,
}:

stdenv.mkDerivation {
  pname = "openbabel";
  version = "3.1.1-unstable-2024-12-21";

  src = fetchFromGitHub {
    owner = "openbabel";
    repo = "openbabel";
    rev = "889c350feb179b43aa43985799910149d4eaa2bc";
    hash = "sha256-pJbvKBjpvXNjTZRxD2AqEarqmq+Pq08uvGvog/k/a7k=";
  };

  patches = [
    # <https://github.com/openbabel/openbabel/pull/2784>
    ./fix-cmake-4.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    swig
    pkg-config
  ];

  buildInputs = [
    perl
    zlib
    libxml2
    eigen
    python3
    cairo
    rapidjson
    boost
    maeparser
    coordgenlibs
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "RUN_SWIG" true)
    (lib.cmakeBool "PYTHON_BINDINGS" true)
    (lib.cmakeFeature "PYTHON_INSTDIR" "${placeholder "out"}/${python3.sitePackages}")
  ];

  disabledTests = [
    "test_cifspacegroup_11"
    "pybindtest_obconv_writers"
  ];

  doCheck = true;

  dontUseNinjaCheck = true;

  meta = {
    description = "Toolbox designed to speak the many languages of chemical data";
    homepage = "http://openbabel.org";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ danielbarter ];
  };
}
