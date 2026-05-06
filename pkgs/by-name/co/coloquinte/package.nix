{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  lemon-graph,
  eigen,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coloquinte";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "coloquinte";
    repo = "PlaceRoute";
    rev = finalAttrs.version;
    hash = "sha256-BQg2rVYe1wJOX7YnvgDVpmN6hwBJZKH0fxm+8HC8bvY=";
  };

  # boost 1.89 removed the boost_system stub library
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      'FIND_PACKAGE(Boost REQUIRED COMPONENTS system filesystem iostreams program_options unit_test_framework)' \
      'FIND_PACKAGE(Boost REQUIRED COMPONENTS filesystem iostreams program_options unit_test_framework)'
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    lemon-graph
    eigen
    boost
  ];

  meta = {
    description = "Placement library for electronic circuits";
    homepage = "https://github.com/Coloquinte/PlaceRoute";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
