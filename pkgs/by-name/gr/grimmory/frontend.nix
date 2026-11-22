{
  src,
  version,

  stdenv,
  nodejs_24,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "grimmory-frontend";
  inherit version src;

  strictDeps = true;
  __structuredAttrs = true;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-wOldjA3z+KknkGjLJKz4J0ddWnP3DN/x6jSVuKgI35I=";
  };

  nativeBuildInputs = [
    nodejs_24
    pnpm
    pnpmConfigHook
  ];

  pnpmWorkspaces = [ "grimmory" ];

  env.NG_CLI_ANALYTICS = "false";
  env.CI = "1";

  buildPhase = ''
    runHook preBuild

    pnpm --filter=grimmory run build:prod

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -rv frontend/dist/grimmory/browser/* $out/

    runHook postInstall
  '';
})
