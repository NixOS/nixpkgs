{
  lib,
  buildNpmPackage,
  picoclaw,

  fetchPnpmDeps,
  nodejs,
  pnpmConfigHook,
  pnpm_10,
}:
let
  pnpm = pnpm_10;
in
buildNpmPackage (finalAttrs: {
  pname = "picoclaw-launcher-frontend";
  inherit (picoclaw) src version;

  sourceRoot = "${finalAttrs.src.name}/web/frontend";

  nativeBuildInputs = [
    nodejs
    pnpm
  ];

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-ECZBq/miLE9dkEOx8e8WI68tI0HBb+iFVeztwMVeeKw=";
  };
  npmConfigHook = pnpmConfigHook;

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  meta = lib.removeAttrs picoclaw.meta [ "mainProgram" ];
})
