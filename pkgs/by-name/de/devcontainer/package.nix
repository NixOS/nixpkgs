{
  lib,
  stdenv,
  fetchYarnDeps,
  fetchFromGitHub,
  fixup-yarn-lock,
  nodejs,
  python3,
  makeWrapper,
  git,
  docker,
  yarn,
  docker-compose,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "devcontainer";
  version = "0.60.0";

  src = fetchFromGitHub {
    owner = "devcontainers";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/QznJhw+DYwnj/kdP6f4liJlOFhNQO0y7r4i55bJPug=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-tN7qAvfYmDz5ZtgZL5+ZZtkuxZxvlS9FM3+dGl+daUQ=";
  };

  nativeBuildInputs = [
    yarn
    fixup-yarn-lock
    python3
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror ${finalAttrs.yarnOfflineCache}

    # Without this, yarn will try to download the dependencies
    fixup-yarn-lock yarn.lock

    # set nodedir to prevent node-gyp from downloading headers
    export npm_config_nodedir=${nodejs}

    yarn --offline --frozen-lockfile
    yarn --offline --frozen-lockfile compile-prod

    mkdir -p $out/bin
    mkdir -p $out/libexec
    cp -r dist $out/libexec
    cp devcontainer.js $out/libexec/devcontainer.js
    cp -r node_modules $out/libexec/node_modules
    cp -r $src/scripts $out/libexec/scripts
    runHook postBuild
  '';

  postInstall = ''
    makeWrapper "${nodejs}/bin/node" "$out/bin/devcontainer" \
      --add-flags "$out/libexec/devcontainer.js" \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          docker
          docker-compose
        ]
      }
  '';

  meta = with lib; {
    description = "Dev container CLI, run and manage your dev environments via a devcontainer.json";
    homepage = "https://containers.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ rucadi ];
    platforms = platforms.unix;
    mainProgram = "devcontainer";
  };
})
