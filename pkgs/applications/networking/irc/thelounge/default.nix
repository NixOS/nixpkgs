{ lib, stdenv, fetchFromGitHub, fetchYarnDeps, yarn, fixup_yarn_lock, nodejs, npmHooks, nixosTests }:

stdenv.mkDerivation (finalAttrs: {
  pname = "thelounge";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "thelounge";
    repo = "thelounge";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2MHq71lKkFe1uHEENgUiYsO99bPyLmEZZIdcdgsZfSM=";
  };

  # Allow setting package path for the NixOS module.
  patches = [ ./packages-path.patch ];

  # Use the NixOS module's state directory by default.
  postPatch = ''
    echo /var/lib/thelounge > .thelounge_home
  '';

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-OKLsNGl94EDyLgP2X2tiwihgRQFXGvf5XgXwgX+JEpk=";
  };

  nativeBuildInputs = [ nodejs yarn fixup_yarn_lock npmHooks.npmInstallHook ];

  configurePhase = ''
    runHook preConfigure

    export HOME="$PWD"

    fixup_yarn_lock yarn.lock
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
    rm -rf node_modules
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive --production
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
  };
})
