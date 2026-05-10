{
  fetchFromGitHub,
  kcl,
  lib,
  pkg-config,
  protobuf,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kcl-language-server";
  version = "0.11.2-unstable-2025-10-26";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "kcl";
    rev = "68b4062e1f6b818b2fc64cfc69ef0a692b35943d";
    hash = "sha256-5yX9TYmn0nGlSI8jiAwxuYpBXq9ie+yVDHwcC1FLcBk=";
  };

  sourceRoot = "${finalAttrs.src.name}/kclvm";

  cargoHash = "sha256-FulW9qNVVZtOoRfm+NPwQENJU9Ib1GBzcjHxk5QS70g=";

  env = {
    PROTOC = "${protobuf}/bin/protoc";
    PROTOC_INCLUDE = "${protobuf}/include";
  };

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
    changelog = "https://github.com/kcl-lang/kcl/releases/tag/v${finalAttrs.version}";
    description = "High-performance implementation of KCL written in Rust that uses LLVM as the compiler backend";
    downloadPage = "https://github.com/kcl-lang/kcl/tree/v${finalAttrs.version}/kclvm/tools/src/LSP";
    homepage = "https://www.kcl-lang.io/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = kcl.meta.maintainers;
    mainProgram = "kcl-language-server";
  };
})
