{
  lib,
  stdenvNoCC,
  fetchPnpmDeps,
  pnpm_11,
  pnpmConfigHook,
  nodejs_24,
  src,
  version,
}:

let
  pnpm = pnpm_11.override {
    nodejs-slim = nodejs_24;
  };

  pnpmDeps = fetchPnpmDeps {
    pname = "buzz-desktop-frontend";
    inherit version src pnpm;
    fetcherVersion = 4;
    hash = "sha256-qxtgbCeivfpAQg2+JOUGCQo7agf0GAARvLle89jFzu4=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "buzz-desktop-frontend";
  inherit version src pnpmDeps;
  strictDeps = true;

  pnpmWorkspaces = [ "buzz" ];

  nativeBuildInputs = [
    nodejs_24
    pnpm
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild
    pnpm --filter buzz build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -R desktop/dist/. "$out/"
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    test -f "$out/index.html"
  '';

  meta = {
    description = "Web frontend for Buzz Desktop";
    homepage = "https://github.com/block/buzz";
    license = lib.licenses.asl20;
  };
}
