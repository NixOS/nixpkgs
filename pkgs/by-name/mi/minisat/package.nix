{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "minisat";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "stp";
    repo = "minisat";
    tag = "releases/${finalAttrs.version}";
    hash = "sha256-iny5WPmR28H8/cnSdWCaK7HFB68LOrH9pQCoSK1cbJM=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 2.6 FATAL_ERROR)' \
      'cmake_minimum_required(VERSION 4.1)'
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  meta = with lib; {
    description = "Compact and readable SAT solver";
    maintainers = with maintainers; [
      raskin
    ];
    platforms = platforms.unix;
    license = licenses.mit;
    homepage = "http://minisat.se/";
  };
})
