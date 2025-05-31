{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "safecloset";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "safecloset";
    rev = "v${version}";
    hash = "sha256-1NvBNITb/KmUC2c+vchvyL9yZbK9xj5Es7AXYg0U9mE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VXxDD/2FFg3uQBdKdHsWOeLfOoCTYdaF+OZJVeQC6gE=";

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
