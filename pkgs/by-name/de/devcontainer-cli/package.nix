{ lib
, stdenvNoCC
, fetchFromGitHub
, fetchYarnDeps
, makeWrapper
, nodejs
, prefetch-yarn-deps
, yarn
, git
, docker
, nodePackages
, testers
, devcontainer-cli
}:

stdenvNoCC.mkDerivation rec {
  pname = "devcontainer-cli";
  version = "0.53.0";

  src = fetchFromGitHub {
    owner = "devcontainers";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-WslXoyE+l26kiKVbwAKAYG5KkFmhT7zUY5mLTq+yP/8=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    hash = "sha256-Ybqjx7FN2J0IzO/rdKh7X57Nw08dzGZtjKr3PXLZEcg=";
  };

  nativeBuildInputs  = [
    makeWrapper
    nodejs
    prefetch-yarn-deps
    yarn
  ];

  runtimeDependencies = [
    git
    docker
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup-yarn-lock yarn.lock
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline definitions
    yarn --offline compile-prod

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    yarn --offline --production install

    rm -rf node_modules/node-pty
    ln -s ${nodePackages.node-pty}/lib/node_modules/node-pty node_modules/node-pty

    mkdir -p "$out/lib/node_modules/@devcontainers/cli"
    cp -r . "$out/lib/node_modules/@devcontainers/cli"

    makeWrapper "${nodejs}/bin/node" "$out/bin/devcontainer" \
      --add-flags "$out/lib/node_modules/@devcontainers/cli/devcontainer.js"

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = devcontainer-cli;
    inherit version;
  };

  meta = with lib; {
    description = "CLI tool for working with vscode devcontainers";
    homepage = "https://github.com/devcontainers/cli";
    changelog = "https://github.com/devcontainers/cli/blob/main/CHANGELOG.md#${lib.replaceStrings ["."] [""] version}";
    license = licenses.mit;
    maintainers = with maintainers; [ h7x4 ];
    mainProgram = "devcontainer";
  };
}
