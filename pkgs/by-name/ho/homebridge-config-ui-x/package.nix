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
  version = "4.73.0";
  src = fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge-config-ui-x";
    tag = "v${version}";
    hash = "sha256-D3FjEUrVEiC15nmFvxW8C0ikOyCYv7F+qBJQgnSr2G0=";
  };

  # Deps src and hash for ui subdirectory
  npmDeps_ui = fetchNpmDeps {
    name = "npm-deps-ui";
    src = "${src}/ui";
    hash = "sha256-UiGwj6CxofCSX8HQlya4utUltwGvb0pqbQk6yxcp/uo=";
  };
in
buildNpmPackage {
  pname = "homebridge-config-ui-x";
  inherit version src;

  nodejs = nodejs_22;

  # Deps hash for the root package
  npmDepsHash = "sha256-9OO7EWhU9DWfsS5WMUaZJJgSSXAP2gA1HpSZXV3242A=";

  # Need to also run npm ci in the ui subdirectory
  preBuild = ''
    # Tricky way to run npmConfigHook multiple times
    (
      source ${npmHooks.npmConfigHook}/nix-support/setup-hook
      npmRoot=ui npmDeps=${npmDeps_ui} makeCacheWritable= npmConfigHook
    )
    # Required to prevent "ng build" from failing due to
    # prompting user for autocompletion
    export CI=true
  '';

  # On darwin, the build failed because openpty() is not declared
  # Uses the prebuild version of @homebridge/node-pty-prebuilt-multiarch instead
  makeCacheWritable = pkgs.stdenv.hostPlatform.isDarwin;

  nativeBuildInputs = with pkgs; [
    python3
    (lib.optional stdenv.hostPlatform.isDarwin cacert)
  ];

  meta = {
    description = "Homebridge Config UI X";
    homepage = "https://github.com/homebridge/homebridge-config-ui-x";
    license = lib.licenses.mit;
    mainProgram = "homebridge-config-ui-x";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ fmoda3 ];
  };
}
