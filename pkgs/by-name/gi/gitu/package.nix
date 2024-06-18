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
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "altsem";
    repo = "gitu";
    rev = "v${version}";
    hash = "sha256-2YcQl9aPFPE/t/Pzoo0mWkCjOE6b4BJH0oT8Gbx+vIg=";
  };

  cargoHash = "sha256-RldCa0UITX8zj5tliww1xiL1Y60t9EN6o1ZA5eVEaT4=";

  nativeBuildInputs = [
    pkg-config
  ];

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
    description = "TUI Git client inspired by Magit";
    homepage = "https://github.com/altsem/gitu";
    changelog = "https://github.com/altsem/gitu/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ evanrichter ];
    mainProgram = "gitu";
  };
}
