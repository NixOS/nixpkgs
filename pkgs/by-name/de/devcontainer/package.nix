{
  lib,
  stdenv,
  fetchYarnDeps,
  fetchFromGitHub,
  fixup-yarn-lock,
  nodejs_20,
  python3,
  makeBinaryWrapper,
  git,
  docker,
  yarn,
  docker-compose,
}:

let
  nodejs = nodejs_20; # does not build with 22
in
stdenv.mkDerivation (finalAttrs: {
  pname = "devcontainer";
  version = "0.72.0";

  src = fetchFromGitHub {
    owner = "devcontainers";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3rSWD6uxwcMQdHBSmmAQ0aevqevVXINigCj06jjEcRc=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-KSVr6RlBEeDAo8D+7laTN+pSH8Ukl6WTpeAULuG2fq8=";
  };

  nativeBuildInputs = [
    yarn
    fixup-yarn-lock
    python3
    makeBinaryWrapper
    nodejs
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

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,libexec}
    cp -r dist $out/libexec
    cp devcontainer.js $out/libexec/devcontainer.js
    cp -r node_modules $out/libexec/node_modules
    cp -r $src/scripts $out/libexec/scripts

    runHook postInstall
  '';

  postInstall = ''
    makeWrapper "${lib.getExe nodejs}" "$out/bin/devcontainer" \
      --add-flags "$out/libexec/devcontainer.js" \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          docker
          docker-compose
        ]
      }
  '';

  meta = {
    description = "Dev container CLI, run and manage your dev environments via a devcontainer.json";
    homepage = "https://containers.dev/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rucadi ];
    platforms = lib.platforms.unix;
    mainProgram = "devcontainer";
  };
})
