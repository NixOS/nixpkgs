{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libiconv
, openssl
, pkg-config
, xclip
, AppKit
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "gitui";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Mz4/Q1EmTg3vXIYbIdr5MtemGrBSkvBBwcfz+McEaJ8=";
  };

  cargoHash = "sha256-hsu3WQfqMnD5frJP6wDcexG7HafXmzs5ZIGePGOBRVs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isLinux xclip
    ++ lib.optionals stdenv.isDarwin [ libiconv Security AppKit ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  # The cargo config overrides linkers for some targets, breaking the build
  # on e.g. `aarch64-linux`. These overrides are not required in the Nix
  # environment: delete them.
  postPatch = "rm .cargo/config";

  meta = with lib; {
    description = "Blazing fast terminal-ui for Git written in Rust";
    homepage = "https://github.com/extrawurst/gitui";
    changelog = "https://github.com/extrawurst/gitui/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne yanganto ];
  };
}
