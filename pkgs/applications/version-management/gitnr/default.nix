{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libxkbcommon
, openssl
, stdenv
, darwin
, wayland
}:

rustPlatform.buildRustPackage rec {
  pname = "gitnr";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "reemus-dev";
    repo = "gitnr";
    rev = "v${version}";
    hash = "sha256-0LuQqDNyMd98cHCG3JDyRx/2hhjNlcGQ7n61Z264WzA=";
  };

  cargoHash = "sha256-H9aLOHdd2UP2YH/dptTwE0bzfFAJk7jwp3ecd0w8bjY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ] ++ lib.optionals stdenv.isLinux [
    libxkbcommon
    wayland
  ];

  # requires internet access
  doCheck = false;

  meta = with lib; {
    description = "Create `.gitignore` files using one or more templates from TopTal, GitHub or your own collection";
    homepage = "https://github.com/reemus-dev/gitnr";
    changelog = "https://github.com/reemus-dev/gitnr/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "gitnr";
  };
}
