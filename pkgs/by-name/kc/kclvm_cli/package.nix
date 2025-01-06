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
  cargoHash = "sha256-nZktEEp0BYusNJL7w9WhX6JK1LCmyi7dI659I9IR+Wo=";
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

  meta = {
    description = "A high-performance implementation of KCL written in Rust that uses LLVM as the compiler backend";
    homepage = "https://github.com/kcl-lang/kcl";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      selfuryon
      peefy
    ];
    mainProgram = "kclvm_cli";
  };
}
