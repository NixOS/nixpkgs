{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  makeWrapper,
  nodejs,
  npmHooks,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "multi-scrobbler";
  version = "0.16.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "FoxxMD";
    repo = "multi-scrobbler";
    tag = finalAttrs.version;
    hash = "sha256-Inzenh6wnv65ZrfdcSEfqXXhW96TabyNvla37zfxtJQ=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-/oQbIxmTRnpfZruMykwv7tQabchYgUgun5tFAoctTRQ=";

  nativeBuildInputs = [ makeWrapper ];

  # The docsite's OG-image plugin needs sharp's native binary, which sharp
  # 0.32.6 fetches from a GitHub release at install time
  postPatch = ''
        substituteInPlace docsite/docusaurus.config.ts \
          --replace-fail \
    "    ],
        [
          '@bony_chops/docusaurus-og',
          {
            path: './preview-images', // relative to the build directory
            imageRenderers: {
                'docusaurus-plugin-content-docs': Renderers.docs,
                'docusaurus-plugin-content-pages': Renderers.docs,
            },
          },
        ]
      ]," \
    "    ],
      ],"
  '';

  # A storybook devDependency refuses to install outside of pnpm, and native
  # modules aren't needed regardless.
  npmRebuildFlags = [ "--ignore-scripts" ];

  # npm's --ignore-scripts skips patch-package too.
  preBuild = ''
    node_modules/.bin/patch-package

    # Both invocations write their writable npm cache to
    # the same $TMPDIR/cache
    rm -rf "$TMPDIR/cache"
    (
      source ${npmHooks.npmConfigHook}/nix-support/setup-hook
      npmRoot=docsite npmDeps=${finalAttrs.passthru.docsiteNpmDeps} npmConfigHook
    )
    (cd docsite && node_modules/.bin/patch-package)

    npm run -s schema:docs
    (cd docsite && CI=true npm run -s build)
  '';

  npmBuildScript = "build:frontend";

  postInstall = ''
    npmPkgDir="$out/lib/node_modules/${finalAttrs.pname}"

    # dist/ and docsite/build/ are gitignored; npm pack omits both.
    cp -r dist "$npmPkgDir/dist"
    mkdir -p "$npmPkgDir/docsite"
    cp -r docsite/build "$npmPkgDir/docsite/build"

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

  passthru = {
    updateScript = nix-update-script { };

    docsiteNpmDeps = fetchNpmDeps {
      name = "multi-scrobbler-docsite-npm-deps";
      src = "${finalAttrs.src}/docsite";
      fetcherVersion = finalAttrs.npmDepsFetcherVersion;
      hash = "sha256-hqpA8vmRHdUOwVXZgiem8rK19ZUtuPdkocamDldioYc=";
    };
  };

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
