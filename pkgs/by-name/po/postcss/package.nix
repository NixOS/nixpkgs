{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm,
  pnpmConfigHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "postcss";
  version = "8.5.10";

  src = fetchFromGitHub {
    owner = "postcss";
    repo = "postcss";
    tag = finalAttrs.version;
    hash = "sha256-fvK4jX1hFkxVABr+uuebnE2OW3dRhoRKMDMH8R0tjuc=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-7SwgvsbSbRj1SZAEhjWp3B4D3VtAvg7UN35/5x3f5Wk=";
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
  };
})
