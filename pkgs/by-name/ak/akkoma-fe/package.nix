{
  lib,
  stdenv,
  fetchFromGitea,
  fetchYarnDeps,
  writableTmpDirAsHomeHook,
  fixup-yarn-lock,
  yarn,
  nodejs,
  jpegoptim,
  oxipng,
  svgo,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "akkoma-fe";
  version = "3.15.0";

  src = fetchFromGitea {
    domain = "akkoma.dev";
    owner = "AkkomaGang";
    repo = "akkoma-fe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VKYeJwAc4pMpF1dWBnx5D39ffNk7eGpJI2es+GAxdow=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-QB523QZX8oBMHWBSFF7MpaWWXc+MgEUaw/2gsCPZ9a4=";
  };

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    fixup-yarn-lock
    yarn
    nodejs
    jpegoptim
    oxipng
    svgo
  ];

  postPatch = ''
    # Build scripts assume to be used within a Git repository checkout
    sed -E -i '/^let commitHash =/,/;$/clet commitHash = "${
      builtins.substring 0 7 finalAttrs.src.rev
    }";' \
      build/webpack.prod.conf.js
  '';

  configurePhase = ''
    runHook preConfigure

    yarn config --offline set yarn-offline-mirror ${lib.escapeShellArg finalAttrs.offlineCache}
    fixup-yarn-lock yarn.lock

    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export NODE_ENV="production"
    export NODE_OPTIONS="--openssl-legacy-provider"
    yarn run build --offline

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # (Losslessly) optimise compression of image artifacts
    find dist -type f -name '*.jpg' -execdir ${jpegoptim}/bin/jpegoptim -w$NIX_BUILD_CORES {} \;
    find dist -type f -name '*.png' -execdir ${oxipng}/bin/oxipng -o max -t $NIX_BUILD_CORES {} \;
    find dist -type f -name '*.svg' -execdir ${svgo}/bin/svgo {} \;

    cp -R -v dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      ''^v(\d+\.\d+\.\d+)$''
    ];
  };

  meta = {
    description = "Frontend for Akkoma";
    homepage = "https://akkoma.dev/AkkomaGang/akkoma-fe/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ mvs ];
  };
})
