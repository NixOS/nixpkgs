{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "gitu";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "altsem";
    repo = "gitu";
    rev = "v${version}";
    hash = "sha256-SQubZazI6ZOQFTAdsfHd/GbdXcCOEX7gvipKduQ5Nr0=";
  };

  cargoHash = "sha256-RunJw5UIVq/L3cCZIJqe3B4TEhMk3xYkUgvuqyMeJ1g=";

  nativeBuildInputs = [
    pkg-config
  ];

  # TODO:
  #   - unvendor tree-sitter (added in 0.18.0)
  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.Security
  ];

  nativeCheckInputs = [
    git
  ];

  meta = with lib; {
    description = "A TUI Git client inspired by Magit";
    homepage = "https://github.com/altsem/gitu";
    changelog = "https://github.com/altsem/gitu/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ evanrichter ];
    mainProgram = "gitu";
  };
}
