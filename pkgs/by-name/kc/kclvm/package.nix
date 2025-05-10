{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  pkg-config,
  rustc,
}:
rustPlatform.buildRustPackage rec {
  pname = "kclvm";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "kcl";
    rev = "v${version}";
    hash = "sha256-6XDLxTpgENhP7F51kicAJB7BNMtX4cONKJApAhqgdno=";
  };

  sourceRoot = "${src.name}/kclvm";

  useFetchCargoVendor = true;
  cargoHash = "sha256-eJ3Gh2l6T2DxJRQRHamPOr/ILtzsqFB497DdXVJ90RE=";

  buildInputs = [ rustc ];

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
