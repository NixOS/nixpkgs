{
  stdenv,
  cmake,
  inja,
  lib,
}:

stdenv.mkDerivation {
  name = "inja-simple-cmake-test";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./main.cpp
      ./CMakeLists.txt
    ];
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [ inja ];
  doInstallCheck = true;
  installCheckPhase = ''
    if [[ `$out/bin/simple-cmake-test` != "Hello world!" ]]; then
      echo "ERROR: $out/bin/simple-cmake-test does not output 'Hello world!'"
      exit 1
    fi
  '';
  meta.timeout = 30;
}
