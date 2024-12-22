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
  version = "0.10.8";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "kcl";
    rev = "v${version}";
    hash = "sha256-ls/Qe/nw3UIfZTjt7r7tzUwxlb5y4jBK2FQlOsMCttM=";
  };

  sourceRoot = "${src.name}/cli";
  cargoHash = "sha256-elIo986ag7x+q17HwkcoqFnD9+1+Jq66XIHYZNaBB/w=";
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
