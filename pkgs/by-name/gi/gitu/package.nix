{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  stdenv,
  darwin,
  git,
}:

rustPlatform.buildRustPackage rec {
  pname = "gitu";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "altsem";
    repo = "gitu";
    rev = "v${version}";
    hash = "sha256-/g+hjQQhu771yqLhx4THaNCJKShXB7RoxiS9bQDUijU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-e9LaVNpApHAShkqt2TawRLWVQ7IoE9hoXlMyMRmpeCY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libgit2
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
      darwin.apple_sdk.frameworks.Security
    ];

  nativeCheckInputs = [
    git
  ];

  meta = with lib; {
    description = "TUI Git client inspired by Magit";
    homepage = "https://github.com/altsem/gitu";
    changelog = "https://github.com/altsem/gitu/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ evanrichter ];
    mainProgram = "gitu";
  };
}
