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
  version = "4.63.0";
  src = fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge-config-ui-x";
    rev = "v${version}";
    hash = "sha256-M0NKbByEp/eyjkSfwuy+AKHBvTY86I1w+VlY6dL25pY=";
  };

  # Deps src and hash for ui subdirectory
  npmDeps_ui = fetchNpmDeps {
    name = "npm-deps-ui";
    src = "${src}/ui";
    hash = "sha256-OWAX/sP8FI3DeYmGDRlImDF/zcJDOBCjbiNgq4SIzxU=";
  };
in
buildNpmPackage rec {
  pname = "homebridge-config-ui-x";
  inherit version src;

  nodejs = nodejs_22;

  # Deps hash for the root package
  npmDepsHash = "sha256-ZLuIzzr4vuYWIfeacNvVbVR8lDlUf8TjZio7+o0CwP0=";

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
