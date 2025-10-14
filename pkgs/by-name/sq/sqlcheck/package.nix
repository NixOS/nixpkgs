{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "sqlcheck";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "jarulraj";
    repo = "sqlcheck";
    tag = "v${version}";
    hash = "sha256-rGqCtEO2K+OT44nYU93mF1bJ07id+ixPkRSC8DcO6rY=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix gcc-13 build failure:
    #   https://github.com/jarulraj/sqlcheck/pull/62
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/jarulraj/sqlcheck/commit/ca131db13b860cf1d9194a1c7f7112f28f49acca.patch";
      hash = "sha256-uoF7rYvjdIUu82JCLXq/UGswgwM6JCpmABP4ItWjDe4=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace external/gflags/CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 3.0.2 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Automatically identify anti-patterns in SQL queries";
    mainProgram = "sqlcheck";
    license = licenses.asl20;
    platforms = with platforms; unix ++ windows;
    maintainers = [ ];
  };
}
