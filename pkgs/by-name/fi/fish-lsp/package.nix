{
  lib,
  stdenv,
  fetchYarnDeps,
  fixup-yarn-lock,
  fetchFromGitHub,
  yarn,
  fish,
  nodejs,
}: let
  src = fetchFromGitHub {
    owner = "ndonfris";
    repo = "fish-lsp";
    rev = "v1.0.7";
    hash = "sha256-Np7ELQxHqSnkzVkASYSyO9cTiO1yrakDuK88kkACNAI=";
  };

  yarnDeps = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-hmaLWO1Sj+2VujrGD2A+COfVE2D+tCnxyojjq1512K4=";
  };
in
  stdenv.mkDerivation
  {
    pname = "fish-lsp";

    version = "1.0.7";

    inherit src;

    nativeBuildInputs = [
      fish
      yarn
      nodejs
      fixup-yarn-lock
    ];

    buildInputs = [
      fish
      nodejs
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      # Yarn writes temporary files to $HOME. Copied from mkYarnModules.
      export HOME=$NIX_BUILD_TOP/yarn_home

      # Make yarn install packages from our offline cache, not the registry
      yarn config --offline set yarn-offline-mirror ${yarnDeps}

      # Fixup "resolved"-entries in yarn.lock to match our offline cache
      fixup-yarn-lock yarn.lock

      yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive

      patchShebangs node_modules/

      substitute ${src}/package.json ./package.json \
        --replace-fail "yarn" "yarn --offline"

      yarn --ignore-scripts --offline run sh:build-wasm
      yarn --ignore-scripts --offline run compile

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstal

      cp -r . "$out"

      runHook postInstall
    '';

    meta = {
      description = "LSP implementation for the fish shell language";
      homepage = "https://github.com/ndonfris/fish-lsp";
      license = lib.licenses.mit;
      mainProgram = "fish-lsp";
      maintainers = with lib.maintainers; [gungun974];
    };
  }
