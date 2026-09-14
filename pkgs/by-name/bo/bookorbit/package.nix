{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  nodejs,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  ffmpeg,
  makeWrapper,
  nixosTests,
}:
let
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bookorbit";
  version = "2.9.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "bookorbit";
    repo = "bookorbit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Dj/H7HWzxscl+uSMGDRgAwLeHDzcZEOM0RsiWrPJjUs=";
  };

  pnpmWorkspaces = [
    "client..."
    "server..."
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-NVI9R6n9HIE2VufTcqe4cjZbTK30R/i6dZy39TGH8qs=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    ffmpeg
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    pnpm --filter client run build-only
    pnpm --filter server run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    pnpm --filter server \
         --config.inject-workspace-packages=true \
         --prod \
         deploy $out/lib

    cp -r client/dist $out/lib/public
    cp -r server/src/db/migrations $out/lib/migrations
    cp -r koreader-plugin $out/lib/koreader-plugin

    makeWrapper ${nodejs}/bin/node $out/bin/bookorbit \
      --run "cd $out/lib" \
      --set NODE_ENV production \
      --set APP_VERSION ${finalAttrs.version} \
      --add-flags "$out/lib/dist/main.js"

    makeWrapper ${nodejs}/bin/node $out/bin/bookorbit-migrate \
      --set NODE_ENV production \
      --add-flags "$out/lib/dist/scripts/migrate.js"

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests) bookorbit;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "BookOrbit, self-hosted library management and reading platform for ebooks, PDFs, audiobooks, and comics.";
    homepage = "https://github.com/bookorbit/bookorbit";
    changelog = "https://github.com/bookorbit/bookorbit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ iv-nn ];
    mainProgram = "bookorbit";
    platforms = lib.platforms.all;
  };
})
