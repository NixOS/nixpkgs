{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, makeWrapper
, nodejs
, prefetch-yarn-deps
, yarn
}:

stdenv.mkDerivation rec {
  pname = "aws-azure-login";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "aws-azure-login";
    repo = "aws-azure-login";
    rev = "v${version}";
    hash = "sha256-PvPnqaKD98h3dCjEOwF+Uc86xCJzn2b9XNHHn13h/2Y=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-SXQPRzF6b1FJl5HkyXNm3kGoNSDXux+0RYXBX93mOts=";
  };

  nativeBuildInputs  = [
    makeWrapper
    nodejs
    prefetch-yarn-deps
    yarn
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

    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    yarn --offline --production install

    mkdir -p "$out/lib/node_modules/aws-azure-login"
    cp -r . "$out/lib/node_modules/aws-azure-login"

    makeWrapper "${nodejs}/bin/node" "$out/bin/aws-azure-login" \
      --add-flags "$out/lib/node_modules/aws-azure-login/lib/index.js"

    runHook postInstall
  '';

  meta = {
    description = "Use Azure AD SSO to log into the AWS via CLI";
    homepage = "https://github.com/aws-azure-login/aws-azure-login";
    license = lib.licenses.mit;
    mainProgram = "aws-azure-login";
    maintainers = with lib.maintainers; [ yurrriq ];
    platforms = lib.platforms.all;
  };
}
