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
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "altsem";
    repo = "gitu";
    rev = "v${version}";
    hash = "sha256-eG3ORk4nD8htdZpboEgcR4P94aKUX7eDHo6uTfSw2Zo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-HiP4fE3rU8j7DZ+qNkrtohXgrljN0PPlg6aYj575L3Q=";

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
