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
  version = "0.24.3";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mT5toF4mKRP0dlwlfKHjmFFQJ/cWSb2vwg1uZbhZRhI=";
  };

  cargoHash = "sha256-8j0NtJB2ErrpljPHSMRD/4IGZuqA8wLuzPnuQqxaXRg=";

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


  # Getting app_config_path fails with a permission denied
  checkFlags = [
    "--skip=keys::key_config::tests::test_symbolic_links"
  ];


  meta = with lib; {
    description = "Blazing fast terminal-ui for Git written in Rust";
    homepage = "https://github.com/extrawurst/gitui";
    changelog = "https://github.com/extrawurst/gitui/blob/v${version}/CHANGELOG.md";
    mainProgram = "gitui";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne yanganto mfrw ];
  };
}
