{
  lib,
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
  version = "1.19.1";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = "gleam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hgi/t4xqQknvx2i1ulcs1pc7iQUP0TQHuRksNyc4F88=";
  };

  cargoHash = "sha256-XazhZxqFS+XZhynWH20H5c4yCHQUhi0fcwBrK00sHaM=";

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
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Statically typed language for the Erlang VM and JavaScript";
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
