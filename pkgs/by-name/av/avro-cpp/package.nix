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

  # TODO: remove fmt formatter patches when updating to next version
  # Patches exist upstream but don't apply cleanly.
  patches = [
    ./0001-get-rid-of-fmt-fetchcontent.patch
    ./0002-fix-fmt-name-formatter.patch
    ./0003-fix-fmt-type-formatter.patch
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
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "C++ library which implements parts of the Avro Specification";
    mainProgram = "avrogencpp";
    homepage = "https://avro.apache.org/";
    license = lib.licenses.asl20;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = with lib.maintainers; [ rasendubi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = lib.platforms.all;
  };
}
