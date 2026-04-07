{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  nodejs_20,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  plus-jakarta-sans,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kanbn";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "kanbn";
    repo = "kan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vI/JS3ZJBuNMJmyhzSTMT6reYwx+5jTP5IICWbPL0x4=";
  };

  postPatch = ''
    # The build sandbox has no network access, so swap the next/font/google
    # import for a local TTF shipped via the plus-jakarta-sans nixpkg.
    mkdir -p apps/web/src/fonts
    cp ${plus-jakarta-sans}/share/fonts/truetype/PlusJakartaSans-Regular.ttf \
      apps/web/src/fonts/PlusJakartaSans.ttf

    # The upstream middleware redirects "/" -> "/login" using a URL built from
    # `request.url`, which yields a *relative* `Location` header. Browsers then
    # resolve it against whatever host the user typed (often localhost), so a
    # request via the public hostname can end up on localhost. Anchor the
    # redirect on NEXT_PUBLIC_BASE_URL when it is set so we always emit an
    # absolute URL pointing at the configured public origin.
    substituteInPlace apps/web/src/middleware.ts \
      --replace-fail \
        'const loginUrl = new URL("/login", request.url);' \
        'const loginUrl = new URL("/login", env("NEXT_PUBLIC_BASE_URL") ?? request.url);'

    substituteInPlace apps/web/src/pages/_app.tsx \
      --replace-fail \
        'import { Plus_Jakarta_Sans } from "next/font/google";' \
        'import localFont from "next/font/local";' \
      --replace-fail \
        'const jakarta = Plus_Jakarta_Sans({
  subsets: ["latin"],
  display: "swap",
});' \
        'const jakarta = localFont({ src: "../fonts/PlusJakartaSans.ttf", display: "swap" });'
  '';

  nativeBuildInputs = [
    nodejs_20
    pnpm_9
    pnpmConfigHook
    makeWrapper
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-I41ZQ5zQ8KPFRlw5eGzN4xCGkarz3LGJcHJ/4NUGTKI=";
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

    makeWrapper ${lib.getExe nodejs_20} $out/bin/kanbn \
      --add-flags "$LIB/web/bootstrap.cjs" \
      --set-default HOSTNAME "0.0.0.0" \
      --set-default PORT "3000" \
      --set NODE_ENV "production"

    makeWrapper ${lib.getExe nodejs_20} $out/bin/kanbn-migrate \
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
    maintainers = with lib.maintainers; [ mkg20001 ];
    mainProgram = "kanbn";
    platforms = lib.platforms.linux;
  };
})
