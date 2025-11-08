{
  lib,
  stdenv,
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
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # Snapshot tests fail because a warning is shown on stdout
    # warn: CPU lacks AVX support, strange crashes may occur. Reinstall Bun or use *-baseline build:
    #   https://github.com/oven-sh/bun/releases/download/bun-v1.3.1/bun-darwin-x64-baseline.zip
    "--skip=tests::echo::echo_bitarray"
    "--skip=tests::echo::echo_bool"
    "--skip=tests::echo::echo_charlist"
    "--skip=tests::echo::echo_circular_reference"
    "--skip=tests::echo::echo_custom_type"
    "--skip=tests::echo::echo_float"
    "--skip=tests::echo::echo_function"
    "--skip=tests::echo::echo_importing_module_named_inspect"
    "--skip=tests::echo::echo_int"
    "--skip=tests::echo::echo_list"
    "--skip=tests::echo::echo_nil"
    "--skip=tests::echo::echo_singleton"
    "--skip=tests::echo::echo_string"
    "--skip=tests::echo::echo_tuple"
    "--skip=tests::echo::echo_with_message"
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
