{
  lib,
  clangStdenv,
  cmake,
  google-dawn,
  spdlog,
  linkFarm,
  symlinkJoin,
}:
clangStdenv.mkDerivation {
  pname = "google-dawn-test";
  version = google-dawn.version;

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./CMakeLists.txt
      ./test.cpp
    ];
  };
  cmakeFlags = [
    "-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"
  ];
  nativeBuildInputs = [ cmake ];

  buildInputs = [
    google-dawn
    spdlog
  ];

  doCheck = true;

  installPhase = ''
    touch $out
  '';

  checkPhase = ''
    ./test
  '';
}
