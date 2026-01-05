{
  fetchFromGitHub,
  kcl,
  lib,
  pkg-config,
  protobuf,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "kcl-language-server";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "kcl";
    rev = "v${version}";
    hash = "sha256-6XDLxTpgENhP7F51kicAJB7BNMtX4cONKJApAhqgdno=";
  };

  sourceRoot = "${src.name}/kclvm";

  cargoHash = "sha256-eJ3Gh2l6T2DxJRQRHamPOr/ILtzsqFB497DdXVJ90RE=";

  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  buildAndTestSubdir = "tools/src/LSP";

  buildPhaseCargoFlags = [
    "--profile"
    "release"
    "--offline"
  ];

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  doCheck = false;

  meta = {
    changelog = "https://github.com/kcl-lang/kcl/releases/tag/v${version}";
    description = "High-performance implementation of KCL written in Rust that uses LLVM as the compiler backend";
    downloadPage = "https://github.com/kcl-lang/kcl/tree/v${version}/kclvm/tools/src/LSP";
    homepage = "https://www.kcl-lang.io/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = kcl.meta.maintainers;
    mainProgram = "kcl-language-server";
  };
}
