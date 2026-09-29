{
  lib,
  stdenv,
  rustPlatform,

  fetchFromGitHub,
  git,
  pkg-config,
  beamPackages,
  nodejs,
  bun,
  deno,
  versionCheckHook,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gleam";
  version = "1.19.0-rc3";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = "gleam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X1ijdo2mTHywEWJ987U69qH7K3nI3N6fR1O2t1CO/ys=";
  };

  cargoHash = "sha256-SHDQMP/QOYS72NCohtm5j/sMmgUlcXnCi9wrdcnPh2c=";

  nativeBuildInputs = [
    pkg-config
  ];

  nativeCheckInputs = [
    # used by several tests
    git

    # erlang runtime is used for integration tests
    beamPackages.erlang

    # js runtimes used for integration tests
    nodejs
    bun
    deno

    writableTmpDirAsHomeHook
  ];

  checkFlags = [
    # These tests make network requests
    "--skip=tests::output::echo_dict"
    "--skip=tests::escript_success_with_dependency"
    # checks files that would be gitignored, but we're not in a git repo
    "--skip=tests::all_files_have_copyright_notice"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # Snapshot tests fail because a warning is shown on stdout
    # warn: CPU lacks AVX support, strange crashes may occur. Reinstall Bun or use *-baseline build:
    #   https://github.com/oven-sh/bun/releases/download/bun-v1.3.1/bun-darwin-x64-baseline.zip
    "--skip=tests::output::echo_bitarray"
    "--skip=tests::output::echo_bool"
    "--skip=tests::output::echo_charlist"
    "--skip=tests::output::echo_circular_reference"
    "--skip=tests::output::echo_custom_type"
    "--skip=tests::output::echo_float"
    "--skip=tests::output::echo_function"
    "--skip=tests::output::echo_importing_module_named_inspect"
    "--skip=tests::output::echo_int"
    "--skip=tests::output::echo_list"
    "--skip=tests::output::echo_nil"
    "--skip=tests::output::echo_singleton"
    "--skip=tests::output::echo_string"
    "--skip=tests::output::echo_tuple"
    "--skip=tests::output::echo_with_message"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Statically typed language for the Erlang VM";
    mainProgram = "gleam";
    homepage = "https://gleam.run/";
    changelog = "https://github.com/gleam-lang/gleam/blob/v${finalAttrs.version}/changelog/v${lib.versions.majorMinor finalAttrs.version}.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      philtaken
      llakala
      ginkogruen
    ];
    teams = [ lib.teams.beam ];
  };
})
