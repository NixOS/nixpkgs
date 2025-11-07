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

stdenv.mkDerivation rec {
  pname = "avro-c++";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "avro";
    tag = "release-${version}";
    hash = "sha256-o1eZgvj3oYIofmmCdBJtCnErZx5srXGo0rVLAMhfwso=";
  };

  sourceRoot = "${src.name}/lang/c++";

  nativeBuildInputs = [
    cmake
    python3
  ];

  propagatedBuildInputs = [
    boost
    fmt
    zlib
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
