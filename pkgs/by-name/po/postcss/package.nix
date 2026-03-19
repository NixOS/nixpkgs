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
  version = "8.5.8";

  src = fetchFromGitHub {
    owner = "postcss";
    repo = "postcss";
    tag = finalAttrs.version;
    hash = "sha256-28IUSx5R1KbyM8OV0U7FrhU+qL2zaJShMVvSQMChcA4=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-SwTVjgS4Hkl1SgXqSdjjbyKqUW2TfD1ruLu2Jcl51gg=";
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
    maintainers = with lib.maintainers; [ pyrox0 ];
    platforms = lib.platforms.all;
  };
})
