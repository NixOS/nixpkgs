{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  pkg-config,
  darwin,
  rustc,
}:
rustPlatform.buildRustPackage rec {
  pname = "kclvm";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "kcl";
    rev = "v${version}";
    hash = "sha256-OMPo2cT0ngwHuGghVSfGoDgf+FThj2GsZ3Myb1wSxQM=";
  };

  sourceRoot = "${src.name}/kclvm";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "inkwell-0.2.0" = "sha256-JxSlhShb3JPhsXK8nGFi2uGPp8XqZUSiqniLBrhr+sM=";
      "protoc-bin-vendored-3.2.0" = "sha256-cYLAjjuYWat+8RS3vtNVS/NAJYw2NGeMADzGBL1L2Ww=";
    };
  };

  buildInputs =
    [ rustc ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -id $out/lib/libkclvm_cli_cdylib.dylib $out/lib/libkclvm_cli_cdylib.dylib
  '';

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  patches = [ ./enable_protoc_env.patch ];

  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  meta = with lib; {
    description = "A high-performance implementation of KCL written in Rust that uses LLVM as the compiler backend";
    homepage = "https://github.com/kcl-lang/kcl";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      selfuryon
      peefy
    ];
  };
}
