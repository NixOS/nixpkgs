{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libiconv,
  openssl,
  pkg-config,
  xclip,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "gitui";
  version = "0.26.3";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = "gitui";
    rev = "v${version}";
    hash = "sha256-j3y+KjC+o9p2omf4bN8+XevwU7WqiaQ0sfPqHySD2ik=";
  };

  cargoHash = "sha256-vVEo0kSghOQsH3T6ZTAzN7gIUku0n7rDbKwNmOM9GZc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optional stdenv.hostPlatform.isLinux xclip
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.AppKit
    ];

  postPatch = ''
    # The cargo config overrides linkers for some targets, breaking the build
    # on e.g. `aarch64-linux`. These overrides are not required in the Nix
    # environment: delete them.
    rm .cargo/config.toml

    # build script tries to get version information from git
    rm build.rs
    substituteInPlace Cargo.toml --replace-fail 'build = "build.rs"' ""
  '';

  GITUI_BUILD_NAME = version;
  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  # Getting app_config_path fails with a permission denied
  checkFlags = [
    "--skip=keys::key_config::tests::test_symbolic_links"
  ];

  meta = {
    description = "Blazing fast terminal-ui for Git written in Rust";
    homepage = "https://github.com/extrawurst/gitui";
    changelog = "https://github.com/extrawurst/gitui/blob/v${version}/CHANGELOG.md";
    mainProgram = "gitui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Br1ght0ne
      yanganto
      mfrw
    ];
  };
}
