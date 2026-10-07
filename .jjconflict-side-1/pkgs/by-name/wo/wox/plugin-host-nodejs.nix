{
  lib,
  stdenv,
  wox,
  fetchPnpmDeps,
  nodejs,
  pnpmConfigHook,
  pnpm_11,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wox-plugin-host-nodejs";
  inherit (wox)
    version
    src
    ;

  sourceRoot = "${finalAttrs.src.name}/wox.plugin.host.nodejs";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-6zQDbNUxysqwrRaEMp8Sb5Vcf2HdkkdrdCpJwG8pHSs=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_11
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 dist/index.js $out/node-host.js

    runHook postInstall
  '';

  meta = {
    inherit (wox.meta)
      description
      homepage
      license
      maintainers
      ;
  };
})
