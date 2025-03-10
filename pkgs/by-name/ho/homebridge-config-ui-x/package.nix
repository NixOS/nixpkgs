{
  lib,
  pkgs,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  nodejs_22,
}:

let
  version = "4.71.2";
  src = fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge-config-ui-x";
    rev = "v${version}";
    hash = "sha256-hzlfKBKyueMHzjeGzqiz4mYxQVcWoBW0K+M6H5Xy3aA=";
  };

  # Deps src and hash for ui subdirectory
  npmDeps_ui = fetchNpmDeps {
    name = "npm-deps-ui";
    src = "${src}/ui";
    hash = "sha256-28jw+w/WLd7lR9ewmvA033D4Fj22qIWe8aUu23oLjLs=";
  };
in
buildNpmPackage rec {
  pname = "homebridge-config-ui-x";
  inherit version src;

  nodejs = nodejs_22;

  # Deps hash for the root package
  npmDepsHash = "sha256-YOvmtDg//9Th29dT2Ai2Z4xfl9f8kI7I/4zZ9yFQukA=";

  # Need to also run npm ci in the ui subdirectory
  preBuild = ''
    # Tricky way to run npmConfigHook multiple times
    (
      source ${npmHooks.npmConfigHook}/nix-support/setup-hook
      npmRoot=ui npmDeps=${npmDeps_ui} npmConfigHook
    )
    # Required to prevent "ng build" from failing due to
    # prompting user for autocompletion
    export CI=true
  '';

  nativeBuildInputs = with pkgs; [
    python3
  ];

  meta = {
    description = "Homebridge Config UI X";
    homepage = "https://github.com/homebridge/homebridge-config-ui-x";
    license = lib.licenses.mit;
    mainProgram = "homebridge-config-ui-x";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fmoda3 ];
  };
}
