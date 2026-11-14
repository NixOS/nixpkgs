{
  lib,
  stdenvNoCC,
  callPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  nixosTests,
  nix-update-script,
  nodejs,
  openssl,
  prisma-engines_6,
  prisma_6,
}:

let
  engineEnv = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ openssl ])
    "--set-default"
    "PRISMA_QUERY_ENGINE_LIBRARY"
    "${prisma-engines_6}/lib/libquery_engine.node"
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pingvin-share-x";
  version = "1.22.3";

  src = fetchFromGitHub {
    owner = "smp46";
    repo = "pingvin-share-x";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xtsI9Ow7K/9pXEZdvBICF5aWAa+Hh7VfNUTwejz4Xno=";
  };

  dontUnpack = true;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/pingvin-share-x
    ln -s ${finalAttrs.passthru.backend} $out/share/pingvin-share-x/backend
    ln -s ${finalAttrs.passthru.frontend} $out/share/pingvin-share-x/frontend

    makeWrapper ${lib.getExe nodejs} $out/bin/pingvin-share-x-frontend \
      --add-flags ${finalAttrs.passthru.frontend}/server.js \
      --set-default NODE_ENV production \
      --set-default NEXT_TELEMETRY_DISABLED 1

    makeWrapper ${lib.getExe nodejs} $out/bin/pingvin-share-x-backend \
      --add-flags ${finalAttrs.passthru.backend}/dist/src/main.js \
      --set-default NODE_ENV production \
      ${lib.escapeShellArgs engineEnv}

    makeWrapper ${lib.getExe nodejs} $out/bin/pingvin-share-x-seed \
      --add-flags ${finalAttrs.passthru.backend}/dist/prisma/seed/config.seed.js \
      ${lib.escapeShellArgs engineEnv}

    makeWrapper ${lib.getExe prisma_6} $out/bin/pingvin-share-x-migrate \
      --add-flags "migrate deploy --schema ${finalAttrs.passthru.backend}/prisma/schema.prisma" \
      --set-default CHECKPOINT_DISABLE 1 \
      --set-default PRISMA_HIDE_UPDATE_MESSAGE 1 \
      ${lib.escapeShellArgs engineEnv}

    runHook postInstall
  '';

  passthru =
    let
      args = {
        inherit (finalAttrs) src version;
        meta = removeAttrs finalAttrs.meta [ "mainProgram" ];
        inherit (finalAttrs.passthru) imagesDir;
        inherit nodejs;
      };
    in
    {
      # The backend writes uploaded logos here and the frontend serves /img from it.
      imagesDir = "/var/lib/pingvin-share-x/images";
      backend = callPackage ./backend.nix args;
      frontend = callPackage ./frontend.nix args;
      tests = { inherit (nixosTests) pingvin-share-x; };
      updateScript = nix-update-script {
        extraArgs = [
          "--subpackage"
          "backend"
          "--subpackage"
          "frontend"
        ];
      };
    };

  meta = {
    description = "Self-hosted file sharing platform, maintained fork of Pingvin Share";
    homepage = "https://github.com/smp46/pingvin-share-x";
    changelog = "https://github.com/smp46/pingvin-share-x/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ znaniye ];
    mainProgram = "pingvin-share-x-backend";
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      # prebuilt sharp/libvips binaries from npm
      binaryNativeCode
    ];
  };
})
