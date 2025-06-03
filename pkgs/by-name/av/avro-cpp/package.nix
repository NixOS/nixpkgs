{
  lib,
  stdenv,
  fetchurl,
  cmake,
  boost,
  python3,
  fmt,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "avro-c++";
  version = "1.12.0";

  src = fetchurl {
    url = "mirror://apache/avro/avro-${version}/cpp/avro-cpp-${version}.tar.gz";
    hash = "sha256-8u33cSanWw7BrRZncr4Fg1HOo9dESL5+LO8gBQwPmKs=";
  };

  patches = [
    ./0001-get-rid-of-fmt-fetchcontent.patch
  ];

  nativeBuildInputs = [
    cmake
    python3
  ];

  propagatedBuildInputs = [
    boost
    fmt
  ];

  doCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/avrogencpp";
  versionCheckProgramArg = "--version";

  meta = {
    description = "C++ library which implements parts of the Avro Specification";
    mainProgram = "avrogencpp";
    homepage = "https://avro.apache.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rasendubi ];
    platforms = lib.platforms.all;
  };
}
