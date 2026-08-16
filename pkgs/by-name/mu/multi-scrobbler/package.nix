{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "multi-scrobbler";
  version = "0.16.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "FoxxMD";
    repo = "multi-scrobbler";
    tag = finalAttrs.version;
    hash = "sha256-R+CwL+Kp3C5wg1LFt0XlksMtRFt+7YItR3t4QPpND6w=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-aqwiOajXjB6FbHzhXxTSpSxDBWkdYj9O+I1XqoEWgbE=";

  nativeBuildInputs = [ makeWrapper ];

  # A storybook devDependency refuses to install outside of pnpm, and native
  # modules aren't needed regardless.
  npmRebuildFlags = [ "--ignore-scripts" ];

  # npm's --ignore-scripts skips patch-package too.
  preBuild = ''
    node_modules/.bin/patch-package
  '';

  npmBuildScript = "build:frontend";

  postInstall = ''
    npmPkgDir="$out/lib/node_modules/${finalAttrs.pname}"

    # dist/ is gitignored; npm pack omits.
    cp -r dist "$npmPkgDir/dist"

    # node refuses type-stripping for any file under a "node_modules"
    pkgDir="$out/libexec/${finalAttrs.pname}"
    mkdir -p "$out/libexec"
    mv "$npmPkgDir" "$pkgDir"
    rmdir "$out/lib/node_modules" "$out/lib"

    mkdir -p "$out/bin"

    # node 24 runs TypeScript directly (built-in type stripping), no tsx needed.
    makeWrapper "${lib.getExe nodejs}" "$out/bin/${finalAttrs.pname}" \
      --add-flags "$pkgDir/src/backend/index.ts" \
      --set NODE_ENV production \
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
