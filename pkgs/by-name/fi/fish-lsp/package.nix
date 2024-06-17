{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
  fetchYarnDeps,
  fish,
  fixup-yarn-lock,
  nodejs,
  yarn,
}:
mkYarnPackage
rec {
  pname = "fish-lsp";
  version = "1.0.7";
  src = fetchFromGitHub {
    owner = "ndonfris";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Np7ELQxHqSnkzVkASYSyO9cTiO1yrakDuK88kkACNAI=";
  };
  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-hmaLWO1Sj+2VujrGD2A+COfVE2D+tCnxyojjq1512K4=";
  };
  nativeBuildInputs = [
    fish
    fixup-yarn-lock
    nodejs
    yarn
  ];
  buildPhase = ''
    runHook preBuild
    wasm_file=$(find node_modules -type f -a -name tree-sitter-fish.wasm)
    cp -f $wasm_file ./deps/fish-lsp
    yarn run sh:build-time
    yarn --offline compile
    yarn run sh:relink
    # yarn run sh:build-completions
    runHook postBuild
  '';

  meta = {
    description = "LSP implementation for the fish shell language";
    homepage = "https://github.com/ndonfris/fish-lsp";
    license = lib.licenses.mit;
    mainProgram = "fish-lsp";
    maintainers = with lib.maintainers; [gungun974];
  };
}
