{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "safecloset";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "safecloset";
    rev = "v${version}";
    hash = "sha256-buIceYP/dZMDw3tyrzj1bY6+sIIPaVJIVj1L//jZnws=";
  };

  cargoHash = "sha256-rxNp9dOvy/UTx6Q9pzZGccEKmIiWxzWVYyMxb+h5bqw=";

  buildInputs =
    lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
    ]
    ++ lib.optionals stdenv.isLinux [
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
