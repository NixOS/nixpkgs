{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "safecloset";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "safecloset";
    rev = "v${version}";
    hash = "sha256-pTfslMZmP8YzLzTru3b64qQ9qefkPzo9V8/S6eSQBgM=";
  };

  cargoHash = "sha256-b0MD30IJRp06qkYsQsiEI7c4ArY3GCSIh8I16/4eom0=";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    xorg.libxcb
  ];

  checkFlags = [
    # skip flaky test
    "--skip=timer::timer_tests::test_timer_reset"
  ];

  meta = with lib; {
    description = "Cross-platform secure TUI secret locker";
    homepage = "https://github.com/Canop/safecloset";
    changelog = "https://github.com/Canop/safecloset/blob/${src.rev}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "safecloset";
  };
}
