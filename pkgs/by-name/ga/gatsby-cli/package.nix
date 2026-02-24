{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  findutils,
  makeBinaryWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gatsby-cli";
  version = "5.15.0";

  src = fetchFromGitHub {
    owner = "gatsbyjs";
    repo = "gatsby";
    tag = "gatsby-cli@${finalAttrs.version}";
    hash = "sha256-sNNbOV9UuCTYHp4cSK9ngCukUXDNV4iOIc9PPQVYymM=";
  };

  yarnKeepDevDeps = true;

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-wfg9Nj9Z8vyp2NdE+fOTuM+pXnfM/r46CbfuE5f3fGU=";
  };

  yarnBuildScript = "lerna";
  yarnBuildFlags = [
    "run"
    "build"
    "--scope"
    "gatsby-cli"
    "--include-dependencies"
  ];

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    # Needed for executing package.json scripts
    nodejs
    findutils
    makeBinaryWrapper
  ];

  preBuild = ''
    patchShebangs packages/**/node_modules
    yarn run lerna run prepare --scope gatsby-cli --include-dependencies
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/
    mv packages/ $out/lib/packages/
    mv node_modules/* $out/lib/node_modules/

    makeWrapper ${lib.getExe nodejs} $out/bin/gatsby \
      --add-flags $out/lib/packages/gatsby-cli/cli.js \
      --set NODE_PATH $out/lib/node_modules

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      # Fixes an error with having too many versions available
      "--use-github-releases"
      "--version-regex"
      "gatsby@(.*)"
    ];
  };

  meta = {
    changelog = "https://github.com/gatsbyjs/gatsby/releases/tag/gatsby%2540${finalAttrs.version}";
    description = "The Gatsby command line interface";
    homepage = "https://github.com/gatsbyjs/gatsby/tree/master/packages/gatsby-cli#readme";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "gatsby";
  };
})
