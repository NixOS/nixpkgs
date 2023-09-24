{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
# docs
, doxygen
, sphinx
, python311Packages
}:

stdenv.mkDerivation rec {
  pname = "quillcpp";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "odygrd";
    repo = "quill";
    rev = "v${version}";
    hash = "sha256-aPGAinaws60aGinUD926QgM3Mywym7tnNXJRq1xtXA0=";
  };

  patches = [
    (fetchpatch {
      name = "fix-pkg-config-lib-and-include-paths.patch";
      url = "https://patch-diff.githubusercontent.com/raw/odygrd/quill/pull/352.patch";
      hash = "sha256-/p+p6OnGybV86r1jMKj+JbaW/JhwMv6Nbj6dzn4p2sQ=";
    })
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    sphinx
    python311Packages.breathe
    python311Packages.sphinx-rtd-theme
  ];

  cmakeFlags = [
    "-DQUILL_BUILD_TESTS=ON"
    "-DQUILL_DOCS_GEN=ON"
  ];

  meta = with lib; {
    description = "Asynchronous Low Latency C++ Logging Library";
    homepage = "https://github.com/odygrd/quill";
    license = licenses.mit;
    maintainers = with maintainers; [ jacekpoz ];
  };
}
