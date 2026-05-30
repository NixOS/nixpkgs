{
  src,
  version,
  meta,
  stdenv,
  fetchYarnDeps,
  nodejs,
  fixup-yarn-lock,
  yarn,
  yarnConfigHook,
  yarnBuildHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lasuite-drive-frontend";
  inherit src version;

  sourceRoot = "${finalAttrs.src.name}/src/frontend";

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/src/frontend/yarn.lock";
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

  meta = meta // {
    description = "A collaborative file sharing and document management platform that scales. Built with Django and React. Opensource alternative to Sharepoint or Google Drive";
  };
})
