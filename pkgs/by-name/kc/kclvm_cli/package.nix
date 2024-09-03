{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, kclvm
, darwin
, rustc
,
}:
rustPlatform.buildRustPackage rec {
  pname = "kclvm_cli";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "kcl";
    rev = "v${version}";
    hash = "sha256-nk5oJRTBRj0LE2URJqno8AoZ+/342C2tEt8d6k2MAc8=";
  };

  sourceRoot = "${src.name}/cli";
  cargoHash = "sha256-LZUE2J/UYepl5BGf4T4eWKIZfN3mVJtMDLtm0uUmvI8=";
  cargoPatches = [ ./cargo_lock.patch ];

  buildInputs = [ kclvm rustc ] ++ (
    lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.SystemConfiguration
    ]
  );

  meta = with lib; {
    description = "A high-performance implementation of KCL written in Rust that uses LLVM as the compiler backend";
    homepage = "https://github.com/kcl-lang/kcl";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ selfuryon peefy ];
    mainProgram = "kclvm_cli";
  };
}
