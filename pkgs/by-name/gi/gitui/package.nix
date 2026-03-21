{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libiconv,
  openssl,
  pkg-config,
  cmake,
  xclip,
  nix-update-script,
  fetchpatch,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitui";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = "gitui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-B3Cdhhu8ECfpc57TKe6u08Q/Kl4JzUlzw4vtJJ1YAUQ=";
  };

  cargoHash = "sha256-dq5F7NJ0XcJ9x6hVWOboQQn8Liw8n8vkFgQSmTYIkSw=";

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux xclip
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
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

  env = {
    GITUI_BUILD_NAME = finalAttrs.version;
    # Needed to get openssl-sys to use pkg-config.
    OPENSSL_NO_VENDOR = 1;
  };

  # Getting app_config_path fails with a permission denied
  checkFlags = [
    "--skip=keys::key_config::tests::test_symbolic_links"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/extrawurst/gitui/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Blazing fast terminal-ui for Git written in Rust";
    homepage = "https://github.com/extrawurst/gitui";
    license = lib.licenses.mit;
    mainProgram = "gitui";
    maintainers = with lib.maintainers; [
      yanganto
      mfrw
    ];
  };
})
