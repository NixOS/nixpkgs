{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "safecloset";
<<<<<<< HEAD
  version = "1.4.2";
=======
  version = "1.4.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "safecloset";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ZLAgSD03Qfoz+uGjVJF7vCkV1pUWqw6yG/9+redbQQ8=";
  };

  cargoHash = "sha256-BSWUWB8OrdmDtU+cGCVp75hakpdd9G3cs9ythDn4nnY=";
=======
    hash = "sha256-pTfslMZmP8YzLzTru3b64qQ9qefkPzo9V8/S6eSQBgM=";
  };

  cargoHash = "sha256-b0MD30IJRp06qkYsQsiEI7c4ArY3GCSIh8I16/4eom0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    xorg.libxcb
  ];

  checkFlags = [
    # skip flaky test
    "--skip=timer::timer_tests::test_timer_reset"
  ];

<<<<<<< HEAD
  meta = {
    description = "Cross-platform secure TUI secret locker";
    homepage = "https://github.com/Canop/safecloset";
    changelog = "https://github.com/Canop/safecloset/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
=======
  meta = with lib; {
    description = "Cross-platform secure TUI secret locker";
    homepage = "https://github.com/Canop/safecloset";
    changelog = "https://github.com/Canop/safecloset/blob/${src.rev}/CHANGELOG.md";
    license = licenses.agpl3Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "safecloset";
  };
}
