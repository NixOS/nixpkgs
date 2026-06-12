{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "postcss";
  version = "8.5.15";

  src = fetchFromGitHub {
    owner = "postcss";
    repo = "postcss";
    tag = finalAttrs.version;
    hash = "sha256-HNMGYdp6s1flnV71eUc1oH/lw9nARlCOZPs2kRDZ1qI=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-lpp5YHemVI+LVO+g/OXvcEUGBhmfeSith9uhbnyT6Ac=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    rm -rf node_modules
    pnpm install --production --offline --force
    mkdir -p $out/lib/node_modules/postcss
    mv ./* $out/lib/node_modules/postcss

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/postcss/postcss/releases/tag/${finalAttrs.version}";
    description = "Transforming styles with JS plugins";
    homepage = "https://postcss.org/";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
    hasNoMaintainersButDependents = true;
  };
})
