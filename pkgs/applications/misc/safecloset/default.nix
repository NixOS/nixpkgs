{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "safecloset";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "safecloset";
    rev = "v${version}";
    hash = "sha256-HY8HaWGsqKUsqNLFpxrGJvAcVD68fqKX2v7xCiEKuDM=";
  };

  cargoHash = "sha256-geZoqfPgYUd4X903EM7+gq/VPvIClAmlC0nkqWriB0M=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ] ++ lib.optionals stdenv.isLinux [
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
