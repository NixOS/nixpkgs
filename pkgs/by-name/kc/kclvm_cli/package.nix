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
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "kcl";
    rev = "v${version}";
    hash = "sha256-qIaDc10NxQKBH7WRzzkQ6bQfkSqsDrFxSwSX+Hf7qS8=";
  };

  sourceRoot = "${src.name}/cli";
  cargoHash = "sha256-mB4qOUj9qZmbstvBIyaWHEzX3DQ7tLhQKDEvea4Bnyk=";
  cargoPatches = [ ./cargo_lock.patch ];

  buildInputs = [ kclvm rustc ] ++ (
    lib.optionals stdenv.hostPlatform.isDarwin [
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
