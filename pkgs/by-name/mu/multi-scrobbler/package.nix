{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nodejs_24,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "multi-scrobbler";
  version = "0.14.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "FoxxMD";
    repo = "multi-scrobbler";
    tag = finalAttrs.version;
    hash = "sha256-LkJCh2qPHVjNDf2UCC1ZbBq1Db4/FC2rL0MDeKg1OTc=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-fUnUWt0zpWHzbSSQ3Vbf5YDurMWrOKBnCqlNzM5wV2c=";

  nativeBuildInputs = [ makeWrapper ];

  # schema:app writes the JSON schemas that the app needs!
  npmBuildScript = "build:frontend";
  preBuild = ''
    npm run schema:app
  '';

  postInstall = ''
    pkgDir="$out/lib/node_modules/${finalAttrs.pname}"

    # dist/ and generated schemas are gitignored :(; npm pack omits them.
    cp -r dist "$pkgDir/dist"
    mkdir -p "$pkgDir/src/backend/common/schema"
    cp src/backend/common/schema/*.json "$pkgDir/src/backend/common/schema/"

    mkdir -p "$out/bin"

    # We need to declare this explictly or it will fallback to modifying its store location
    makeWrapper "${nodejs_24}/bin/node" "$out/bin/${finalAttrs.pname}" \
      --add-flags "$pkgDir/node_modules/tsx/dist/cli.mjs" \
      --add-flags "$pkgDir/src/backend/index.ts" \
      --set NODE_ENV production \
      --run 'export CONFIG_DIR="''${CONFIG_DIR:-''${HOME}/.config/${finalAttrs.pname}}"' \
      --run 'mkdir -p "$CONFIG_DIR"' \
      --chdir "$pkgDir"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scrobble music from many sources to many clients";
    longDescription = ''
      multi-scrobbler monitors music listening activity from many Sources
      (Spotify, Jellyfin, Plex, Subsonic, Kodi, YouTube Music, Last.fm,
      ListenBrainz, and more) and scrobbles to many Clients (Last.fm,
      ListenBrainz, Maloja, Rocksky, teal.fm, and more).  A web interface
      on port 9078 (PORT env var) provides status, logs, and OAuth flows.
    '';
    homepage = "https://github.com/FoxxMD/multi-scrobbler";
    changelog = "https://github.com/FoxxMD/multi-scrobbler/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "multi-scrobbler";
    platforms = lib.platforms.unix;
  };
})
