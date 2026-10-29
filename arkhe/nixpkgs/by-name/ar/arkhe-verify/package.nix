{
  lib,
  rustPlatform,
  fetchFromGitHub,
  runCommand,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "arkhe-verify";
  version = "0.1.0-unstable-2026-10-29";

  src = fetchFromGitHub {
    owner = "rafael-arkhe";
    repo = "nixpkgs-arkhe";
    rev = "228da8e803e9f81041066e3a3a50f61e6ff4201c";
    hash = "sha256-IX8kHrWuRQn9jOb1mwXwJ9eoMkelO+1PpFlbu/dEiiI=";
  };

  cargoHash = "sha256-J2aSDP8/OcFVQdilWyYs+4f8VXwhxEhT9uSh+8egyH8=";

  cargoBuildFlags = [
    "--frozen"
    "-p"
    "arkhe-verify-cli"
    "--bin"
    "arkhe-verify"
  ];
  cargoTestFlags = [
    "--frozen"
    "-p"
    "arkhe-verify-cli"
    "-p"
    "arkhe-verify-core"
    "-p"
    "arkhe-core"
  ];

  env = {
    SOURCE_DATE_EPOCH = "315532800";
    CARGO_INCREMENTAL = "0";
    CARGO_NET_OFFLINE = "true";
  };

  preBuild = ''
    export RUSTFLAGS="''${RUSTFLAGS-} --remap-path-prefix=$PWD=/build/source --remap-path-prefix=$NIX_BUILD_TOP=/build"
  '';

  postCheck = ''
    set -o pipefail
    cargo test --frozen --release --target ${stdenv.hostPlatform.rust.rustcTargetSpec} \
      -p arkhe-core --test golden_vectors 2>&1 | tee golden-vectors.log
    grep -Eq '^test result: ok\. [1-9][0-9]* passed' golden-vectors.log
    cargo test --frozen --release --target ${stdenv.hostPlatform.rust.rustcTargetSpec} \
      -p arkhe-verify-core --test golden_contract 2>&1 | tee golden-contract.log
    grep -Eq '^test result: ok\. [1-9][0-9]* passed' golden-contract.log
  '';

  passthru.tests.blake3 = runCommand "arkhe-verify-blake3" { } ''
    test "$(${lib.getExe finalAttrs.finalPackage} blake3 "")" = \
      af1349b9f5f9a1a6a0404dea36dcc9499bcb25c9adc112b7cc9a93cae41f3262
    touch "$out"
  '';

  meta = {
    description = "Offline verifier for Arkhe artifacts and attestations";
    homepage = "https://github.com/rafael-arkhe/nixpkgs-arkhe/tree/arkhe/nix-packages-integration/arkhe";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ rafael-arkhe ];
    mainProgram = "arkhe-verify";
    platforms = lib.platforms.linux;
  };
})
