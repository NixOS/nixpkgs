{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  pkg-config,
  openssl,
  erlang,
  nodejs,
  bun,
  deno,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gleam";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = "gleam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-06ap5z1vtv2Rsd98LcLRpvxff1NfkuHNdI844DZuEhQ=";
  };

  cargoHash = "sha256-TzHjXW9sSbOJv7PrUaQzZ0jOPocVci1DjcmLzv7aaBY=";

  nativeBuildInputs = [
    pkg-config
    erlang
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
