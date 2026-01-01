{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
<<<<<<< HEAD
  version = "0.9.115";
=======
  version = "0.9.114";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
<<<<<<< HEAD
    hash = "sha256-Xsej4/GalmC6LIhR3xy+9phPsK5z8tPP8ALFpug4QAA=";
=======
    hash = "sha256-0l8+YKIdKhvwdEbvSgYcX1deq+aRZkxXUCw2zMSO4cU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # FIXME: we don't support dtrace probe generation on macOS until we have a dtrace build: https://github.com/NixOS/nixpkgs/pull/392918
  patches = lib.optionals stdenv.isDarwin [
    ./no-dtrace-macos.patch
  ];

<<<<<<< HEAD
  cargoHash = "sha256-7pvHeyS9gBBq9TtsmiHxTd+wbIm96jPIYuHlNgUH4aM=";
=======
  cargoHash = "sha256-3KiPuDck8THwrOPRpIKhaRZIFO4EoppMDfsm1H4SBoI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  cargoBuildFlags = [
    "-p"
    "cargo-nextest"
  ];
  cargoTestFlags = [
    "-p"
    "cargo-nextest"
  ];

  passthru.updateScript = nix-update-script { };

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Next-generation test runner for Rust projects";
    mainProgram = "cargo-nextest";
    homepage = "https://github.com/nextest-rs/nextest";
    changelog = "https://nexte.st/CHANGELOG.html";
<<<<<<< HEAD
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
=======
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      ekleog
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      matthiasbeyer
    ];
  };
}
