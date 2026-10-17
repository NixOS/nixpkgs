{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  nodejs_24,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  plus-jakarta-sans,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kanbn";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "kanbn";
    repo = "kan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I3jcCfvqSCTxbi3mfFb/ocRchz2jSBP/hQYUwtyYF+c=";
  };

  patches = [
    ./respect-base-url-in-login-redirect.patch
    ./use-local-plus-jakarta-sans.patch
  ];

  postPatch = ''
    # use-local-plus-jakarta-sans.patch switches _app.tsx from next/font/google
    # to next/font/local; drop the TTF it references next to the source.
    mkdir -p apps/web/src/fonts
    cp ${plus-jakarta-sans}/share/fonts/truetype/PlusJakartaSans-Regular.ttf \
      apps/web/src/fonts/PlusJakartaSans.ttf

    # Widen engines.pnpm ("^9.14.2") so the bundled pnpm (>=10) is accepted;
    # the v9 lockfile is read unchanged. Mirrors fetchPnpmDeps.prePnpmInstall.
    sed -i -E 's/("pnpm": ")\^?[0-9][^"]*(")/\1>=9\2/' package.json
  '';

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    nodejs_24
    pnpm_10
    pnpmConfigHook
    makeWrapper
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    # Upstream pins engines.pnpm to "^9.14.2"; nixpkgs only ships supported
    # (non-EOL) pnpm from 10 onwards, which reads the v9 lockfile fine. Widen
    # the engine range so install does not hard-fail on the major mismatch.
    prePnpmInstall = ''
      sed -i -E 's/("pnpm": ")\^?[0-9][^"]*(")/\1>=9\2/' package.json
    '';
    hash = "sha256-usaG3PaEB8J5adutSGM0u3RVbN6UyacebNQYnkhDMaM=";
  };

  env = {
    # Force the standalone Next.js output, matching the upstream Dockerfile.
    NEXT_PUBLIC_USE_STANDALONE_OUTPUT = "true";
    NEXT_PUBLIC_APP_VERSION = finalAttrs.version;
    CI = "true";
  };

  buildPhase = ''
    runHook preBuild

    pushd apps/web
    pnpm exec next build --turbopack
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/doc/kanbn
    cp README.md LICENSE $out/share/doc/kanbn/ || true

    LIB=$out/lib/kanbn
    mkdir -p $LIB

    # --- Web (Next.js standalone) -------------------------------------------
    # Layout matches what apps/web/bootstrap.cjs expects: it requires
    # ./apps/web/server.js relative to its own location and writes to
    # ./apps/web/public/__ENV.js .
    mkdir -p $LIB/web
    cp -a apps/web/.next/standalone/. $LIB/web/
    mkdir -p $LIB/web/apps/web/.next
    cp -a apps/web/.next/static $LIB/web/apps/web/.next/static
    cp -a apps/web/public $LIB/web/apps/web/public
    cp apps/web/bootstrap.cjs $LIB/web/bootstrap.cjs

    # --- DB migrations ------------------------------------------------------
    # Ship the drizzle config + migrations together with the relevant
    # node_modules so `drizzle-kit migrate` can run at deploy time.
    mkdir -p $LIB/db
    cp packages/db/drizzle.config.ts $LIB/db/
    cp -a packages/db/migrations $LIB/db/migrations
    cp -a packages/db/src $LIB/db/src
    cp -a node_modules $LIB/db/node_modules

    # --- Wrappers -----------------------------------------------------------
    mkdir -p $out/bin

    makeWrapper ${lib.getExe nodejs_24} $out/bin/kanbn \
      --add-flags "$LIB/web/bootstrap.cjs" \
      --set-default HOSTNAME "0.0.0.0" \
      --set-default PORT "3000" \
      --set NODE_ENV "production"

    makeWrapper ${lib.getExe nodejs_24} $out/bin/kanbn-migrate \
      --add-flags "$LIB/db/node_modules/.bin/drizzle-kit" \
      --add-flags "migrate" \
      --chdir "$LIB/db"

    runHook postInstall
  '';

  postFixup = ''
    # Drop large build-only dependencies that are not needed at runtime by
    # the standalone server.
    rm -rf $out/lib/kanbn/db/node_modules/{@next,next,@swc,turbo,@turbo} || true
    # Remove broken symlinks left over from pruning.
    find $out/lib/kanbn -type l ! -exec test -e {} \; -delete
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) kanbn; };
  };

  meta = {
    description = "Open source alternative to Trello, Asana and Jira";
    homepage = "https://kan.bn";
    changelog = "https://github.com/kanbn/kan/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      abcsds
      mkg20001
    ];
    mainProgram = "kanbn";
    platforms = lib.platforms.linux;
  };
})
