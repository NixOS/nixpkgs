# If the tests are broken, it's probably for one of two reasons:
#
# 1. The version of llvm used doesn't match the expectations of rustc and/or
#    cargo-llvm-cov.
# 2. Nixpkgs has changed its rust infrastructure in a way that causes
#    cargo-llvm-cov to misbehave under test. It's likely that even though the
#    tests are failing, cargo-llvm-cov will still function properly in actual
#    use. This has happened before, and is described [here][0] (along with a
#    feature request that would fix this instance of the problem).
#
# For previous test-troubleshooting discussion, see [here][1].
#
# [0]: https://github.com/taiki-e/cargo-llvm-cov/issues/242
# [1]: https://github.com/NixOS/nixpkgs/pull/197478

{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  llvmPackages_19,
  gitMinimal,
}:

let
  pname = "cargo-llvm-cov";
  version = "0.6.20";

  owner = "taiki-e";
  homepage = "https://github.com/${owner}/${pname}";

  inherit (llvmPackages_19) llvm;
in

rustPlatform.buildRustPackage (finalAttrs: {
  inherit pname version;

  # Use `fetchFromGitHub` instead of `fetchCrate` because the latter does not
  # pull in fixtures needed for the test suite
  src = fetchFromGitHub {
    inherit owner;
    repo = "cargo-llvm-cov";
    rev = "v${version}";
    sha256 = "sha256-LAiN9Opc0XQVepQ9IhK9JFWGoeRR3U6V680jgGiaDGo=";
  };

  # Upstream doesn't include the lockfile so we need to add it back
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "test-helper-0.0.0" = "sha256-MjylM9agdGIGMp1Iip/jolHCzErST2XiEl5PIqt+ykg=";
    };
  };

  # `cargo-llvm-cov` reads these environment variables to find these binaries,
  # which are needed to run the tests
  LLVM_COV = "${llvm}/bin/llvm-cov";
  LLVM_PROFDATA = "${llvm}/bin/llvm-profdata";

  nativeCheckInputs = [
    gitMinimal
  ];

  # `cargo-llvm-cov` tests rely on `git ls-files.
  preCheck = ''
    git init -b main
    git add .
  '';

  meta = {
    inherit homepage;
    changelog = homepage + "/blob/v${version}/CHANGELOG.md";
    description = "Cargo subcommand to easily use LLVM source-based code coverage";
    mainProgram = "cargo-llvm-cov";
    longDescription = ''
      In order for this to work, you either need to run `rustup component add llvm-
      tools-preview` or install the `llvm-tools-preview` component using your Nix
      library (e.g. fenix or rust-overlay)
    '';
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      wucke13
      matthiasbeyer
      CobaltCause
    ];

    # The profiler runtime is (currently) disabled on non-Linux platforms
    broken = !(stdenv.hostPlatform.isLinux && !stdenv.targetPlatform.isRedox);
  };
})
