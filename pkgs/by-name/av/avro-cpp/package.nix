{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  python3,
  fmt,
  versionCheckHook,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "avro-c++";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "avro";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-hzUXgOcZbLDH9zqhtrCUQFWtYSE1ty4ucGZz23PMVSk=";
  };

  preConfigure = "cd lang/c++";
  cmakeFlags = [
    (lib.cmakeFeature "AVRO_BUILD_TESTS" "OFF")
  ];

  nativeBuildInputs = [
    cmake
    python3
    zlib
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

  meta = {
    description = "C++ library which implements parts of the Avro Specification";
    mainProgram = "avrogencpp";
    homepage = "https://avro.apache.org/";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
