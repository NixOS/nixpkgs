{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, nodejs
, yarn
, fixup-yarn-lock
, python3
, npmHooks
, cctools
, sqlite
, srcOnly
, buildPackages
, nixosTests
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "thelounge";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "thelounge";
    repo = "thelounge";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4FdNYP9VLgv/rfvT7KHCF+ABFsZvPbJjfz6IvvDkRNA=";
  };

  # Allow setting package path for the NixOS module.
  patches = [ ./packages-path.patch ];

  # Use the NixOS module's state directory by default.
  postPatch = ''
    echo /var/lib/thelounge > .thelounge_home
  '';

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-MM6SgVT7Pjdu96A4eWRucEzT7uNPxBqUDgHKl8mH2C0=";
  };

  nativeBuildInputs = [ nodejs yarn fixup-yarn-lock python3 npmHooks.npmInstallHook ] ++ lib.optional stdenv.isDarwin cctools;
  buildInputs = [ sqlite ];

  configurePhase = ''
    runHook preConfigure

    export HOME="$PWD"

    fixup-yarn-lock yarn.lock
    yarn config --offline set yarn-offline-mirror ${finalAttrs.offlineCache}
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    NODE_ENV=production yarn build

    runHook postBuild
  '';

  # `npm prune` doesn't work and/or hangs for whatever reason.
  preInstall = ''
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive --production
    patchShebangs node_modules

    # Build the sqlite3 package.
    npm_config_nodedir="${srcOnly nodejs}" npm_config_node_gyp="${buildPackages.nodejs}/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js" npm rebuild --verbose --sqlite=${sqlite.dev}

    # These files seemingly aren't needed, and also might not exist when the Darwin sandbox is disabled?
    rm -rf node_modules/sqlite3/build-tmp-napi-v6/{Release/obj.target,node_sqlite3.target.mk}
  '';

  dontNpmPrune = true;

  # Takes way, way, way too long.
  dontStrip = true;

  passthru.tests = nixosTests.thelounge;

  meta = with lib; {
    description = "Modern, responsive, cross-platform, self-hosted web IRC client";
    homepage = "https://thelounge.chat";
    changelog = "https://github.com/thelounge/thelounge/releases/tag/v${finalAttrs.version}";
    maintainers = with maintainers; [ winter raitobezarius ];
    license = licenses.mit;
    inherit (nodejs.meta) platforms;
    mainProgram = "thelounge";
  };
})
