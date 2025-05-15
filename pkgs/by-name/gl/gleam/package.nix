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
  version = "1.11.0-rc1";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = "gleam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KKwR9PAehzv8W2PLaaGV+WxYjf8iXWqtaB1x/JbCN28=";
  };

  cargoHash = "sha256-TqCJILBwGFKTe1BcbjVT09tj7DC9J7HmjrAE3Fc0tKw=";

  nativeBuildInputs = [
    git
    pkg-config
    erlang_27
    nodejs
    bun
    deno
  ];

  buildInputs = [ openssl ];

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
