{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  boost,
  catch2,
  cmake,
  clingo,
  re2c,
}:

stdenv.mkDerivation rec {
  version = "1.9.6";
  pname = "aspcud";

  src = fetchFromGitHub {
    owner = "potassco";
    repo = "aspcud";
    rev = "v${version}";
    hash = "sha256-PdRfpmH7zF5dn+feoijtzdSUjaYhjHwyAUfuYoWCL9E=";
  };

  patches = [
    # Bump minimal version of cmake to 3.10
    (fetchpatch {
      url = "https://github.com/potassco/aspcud/commit/d88c1aad6f9c1c0081aa1a0eea94ecc7d4ebf855.patch?full_index=1";
      hash = "sha256-JDNpXLb3ow4JnsZrQ8HqGrRpf/6H/ozJca52pIRVo2w=";
      excludes = [ "cmake/FindRE2C.cmake" ];
    })
  ];

  postPatch = ''
    cp ${catch2}/include/catch2/catch.hpp libcudf/tests/catch.hpp
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    clingo
    re2c
  ];

  cmakeFlags = [
    "-DASPCUD_GRINGO_PATH=${clingo}/bin/gringo"
    "-DASPCUD_CLASP_PATH=${clingo}/bin/clasp"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Solver for package problems in CUDF format using ASP";
    homepage = "https://potassco.org/aspcud/";
    platforms = platforms.all;
    maintainers = [ maintainers.hakuch ];
    license = licenses.gpl3Plus;
  };
}
