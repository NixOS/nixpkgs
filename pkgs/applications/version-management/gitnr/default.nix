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
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "reemus-dev";
    repo = "gitnr";
    rev = "v${version}";
    hash = "sha256-Hsro0y/avI20cFQveQF17NiR3JCNlBKqXbaIce7uxBM=";
  };

  cargoHash = "sha256-Ahzm23AStSwDSgks9j/J15/zo+EH/NgbfCBc3xBcTwQ=";

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
