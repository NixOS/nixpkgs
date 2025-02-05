{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  kclvm,
  darwin,
  rustc,
}:
rustPlatform.buildRustPackage rec {
  pname = "kclvm_cli";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "kcl";
    rev = "v${version}";
    hash = "sha256-wRmLXR1r/FtZVfc6jifEj0jS0U0HIgJzBtuuzLQchjo=";
  };

  sourceRoot = "${src.name}/cli";
  useFetchCargoVendor = true;
  cargoHash = "sha256-ZhrjxHqwWwcVkCVkJJnVm2CZLfRlrI2383ejgI+B2KQ=";
  cargoPatches = [ ./cargo_lock.patch ];

  buildInputs =
    [
      kclvm
      rustc
    ]
    ++ (lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.SystemConfiguration
    ]);

  meta = with lib; {
    description = "A high-performance implementation of KCL written in Rust that uses LLVM as the compiler backend";
    homepage = "https://github.com/kcl-lang/kcl";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      selfuryon
      peefy
    ];
    mainProgram = "kclvm_cli";
  };
}
