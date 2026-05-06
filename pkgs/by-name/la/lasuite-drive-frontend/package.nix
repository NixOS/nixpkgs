{
  lib,
  fetchFromGitHub,
  stdenv,
  fetchYarnDeps,
  nodejs,
  fixup-yarn-lock,
  yarn,
  yarnConfigHook,
  yarnBuildHook,
}:

stdenv.mkDerivation rec {
  pname = "lasuite-drive-frontend";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "drive";
    tag = "v${version}";
    hash = "sha256-GaJUsfH43HNVGwJqNGTpvIm4MbKJYTN0ZHT7ehWk4aQ=";
  };

  sourceRoot = "source/src/frontend";

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/src/frontend/yarn.lock";
    hash = "sha256-yUKJp6yUTxpvkaA+YuQC3r1t4LBvuYMv1xesLewbK/U=";
  };

  nativeBuildInputs = [
    nodejs
    fixup-yarn-lock
    yarn
    yarnConfigHook
    yarnBuildHook
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    cp -r apps/drive/out/ $out

    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    description = "A collaborative file sharing and document management platform that scales. Built with Django and React. Opensource alternative to Sharepoint or Google Drive";
    homepage = "https://github.com/suitenumerique/drive";
    changelog = "https://github.com/suitenumerique/drive/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.all;
  };
}
