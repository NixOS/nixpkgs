{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  pkg-config,
  openssl,
  erlang_27,
  nodejs,
  bun,
  deno,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gleam";
  version = "1.12.0-rc1";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = "gleam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TBf8+6qZlTF/IYkoT7sqlGWzCznV5rdmnp8xtzHnM4Q=";
  };

  cargoHash = "sha256-YW9WpTKtI5maoDF6rwLl8v2gq2uJQJSLWf0bRCug+RI=";

  nativeBuildInputs = [
    pkg-config
    erlang_27
  ];

  buildInputs = [ openssl ];

  nativeCheckInputs = [
    # used by several tests
    git

    # js runtimes used for integration tests
    nodejs
    bun
    deno
  ];

  checkFlags = [
    # Makes a network request
    "--skip=tests::echo::echo_dict"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Statically typed language for the Erlang VM";
    mainProgram = "gleam";
    homepage = "https://gleam.run/";
    changelog = "https://github.com/gleam-lang/gleam/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      philtaken
      llakala
    ];
    teams = [ lib.teams.beam ];
  };
})
