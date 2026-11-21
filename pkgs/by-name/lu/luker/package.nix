{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "luker";
  version = "2.8.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "funnycups";
    repo = "Luker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nL3s65qSvtYAo1duagzJkI8zx2kT1dmtCuTbKAdRxlc=";
  };

  npmDepsHash = "sha256-0iXiBigRcpxFz0Nrd7DuQJqQZpRN7p+XWeoVwEZusoY=";

  npmFlags = [
    "--no-audit"
    "--no-fund"
  ];
  npmInstallFlags = [ "--omit=dev" ];

  env.NODE_ENV = "production";

  postPatch = ''
    rm .npmrc
    substituteInPlace src/util.js --replace-fail 'LUKER_UPDATE_REMOTE ||' 'LUKER_UPDATE_REMOTE ??'
  '';

  buildPhase = ''
    runHook preBuild

    node ./docker/build-lib.js

    runHook postBuild
  '';

  postInstall = ''
    mkdir -p $out/lib/node_modules/luker/{backups,public/scripts/extensions/third-party}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SillyTavern fork focused on customizable AI chat interfaces";
    homepage = "https://github.com/funnycups/Luker";
    changelog = "https://github.com/funnycups/Luker/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/funnycups/Luker/releases";
    license = lib.licenses.agpl3Plus;
    mainProgram = "luker";
    maintainers = with lib.maintainers; [ MCSeekeri ];
  };
})
