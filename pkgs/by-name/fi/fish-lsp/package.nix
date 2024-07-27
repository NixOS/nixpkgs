{
  fetchFromGitHub,
  fetchYarnDeps,
  fish,
  fixup-yarn-lock,
  installShellFiles,
  lib,
  makeWrapper,
  mkYarnPackage,
  nix-update-script,
  nodejs,
  which,
  yarn,
}:
mkYarnPackage rec {
  pname = "fish-lsp";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "ndonfris";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Lc2AmvcLdgPoLyT/6bPCI/pkb4x6M6XilZDr8IxKeHc=";
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-hHw7DbeqaCapqx4dK5Y3sPut94ist9JOU8g9dd6gBdo=";
  };

  nativeBuildInputs = [
    fish
    fixup-yarn-lock
    installShellFiles
    makeWrapper
    nodejs
    which
    yarn
  ];

  buildPhase = ''
    runHook preBuild

    export fish_wasm_file=$(find node_modules -type f -a -name tree-sitter-fish.wasm | xargs realpath)
    yarn setup
    yarn --offline compile

    runHook postBuild
  '';

  postInstall = ''
    makeWrapper ${lib.getExe nodejs} "$out/bin/fish-lsp" \
      --add-flags "$out/libexec/fish-lsp/deps/fish-lsp/out/cli.js"

    installShellCompletion --cmd fish-lsp \
      --fish <($out/bin/fish-lsp complete --fish)
  '';

  doDist = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "LSP implementation for the fish shell language";
    homepage = "https://github.com/ndonfris/fish-lsp";
    license = lib.licenses.mit;
    mainProgram = "fish-lsp";
    maintainers = with lib.maintainers; [
      gungun974
      petertriho
    ];
  };
}
