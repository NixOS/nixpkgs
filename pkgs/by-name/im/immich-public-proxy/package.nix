{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  nixosTests,
  nodejs,
}:
buildNpmPackage rec {
  pname = "immich-public-proxy";
  version = "4.1.1";
  src = fetchFromGitHub {
    owner = "alangrainger";
    repo = "immich-public-proxy";
    tag = "v${version}";
    hash = "sha256-Ozm6vQ3me9xa4qxcho5sUD1UZiQxquPDgjJqqoKz6Jo=";
  };

  npmDepsHash = "sha256-kwGHYuP0PDxs+7GpiGsdKq6o+F6Hu0Fi7mBdwI8Ciws=";

  nativeBuildInputs = [ makeWrapper ];

  # The repo is an npm workspace (shared/, app/, upload-app/). The default install
  # phase packs a single package, but both programs need the whole workspace.
  dontNpmInstall = true;

  installPhase = ''
    runHook preInstall

    npm prune --omit=dev --no-audit --no-fund

    mkdir -p $out/lib/ipp
    cp -r package.json node_modules shared app upload-app $out/lib/ipp/

    # Both programs serve ./public relative to the working directory
    makeWrapper ${lib.getExe nodejs} $out/bin/immich-public-proxy \
      --chdir $out/lib/ipp/app \
      --add-flags $out/lib/ipp/app/dist/index.js \
      --set NODE_ENV production
    makeWrapper ${lib.getExe nodejs} $out/bin/immich-public-proxy-upload \
      --chdir $out/lib/ipp/upload-app \
      --add-flags $out/lib/ipp/upload-app/dist/index.js \
      --set NODE_ENV production

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests) immich-public-proxy;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/alangrainger/immich-public-proxy/releases/tag/${src.tag}";
    description = "Share your Immich photos and albums in a safe way without exposing your Immich instance to the public";
    homepage = "https://github.com/alangrainger/immich-public-proxy";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jaculabilis
      parkuman
    ];
    inherit (nodejs.meta) platforms;
    mainProgram = "immich-public-proxy";
  };
}
