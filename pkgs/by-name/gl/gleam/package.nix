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
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = "gleam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0qK9dWkKnoXbIIBMN3p5noPEke/bgC8Bjtmf6lwtyr4=";
  };

  cargoHash = "sha256-EoRu8p6cUe1li54nVUkf+3qywIsDXh4ptIVLluJ3eFs=";

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
    maintainers = lib.teams.beam.members ++ [ lib.maintainers.philtaken ];
  };
})
