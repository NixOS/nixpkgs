{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarn,
  fixup-yarn-lock,
  prefetch-yarn-deps,
  nixosTests,
  nodejs_20,
  nodejs-slim_20,
  remarshal_0_17,
  settings ? { },
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dashy-ui";
  version = "3.1.1-unstable-2025-09-12";
  src = fetchFromGitHub {
    owner = "lissy93";
    repo = "dashy";
    rev = "e70ade555fdccf4e723a90f8a2d46fcf83645c4f";
    hash = "sha256-edsGHc6Hi306aq+TA2g5FL/ZYNfExbcgHS5PWF9O0+0=";
  };
  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-r36w3Cz/V7E/xPYYpvfQsdk2QXfCVDYE9OxiFNyKP2s=";
  };

  passthru.tests = {
    dashy = nixosTests.dashy;
  };

  # - If no settings are passed, use the default config provided by upstream
  # - Despite JSON being valid YAML (and the JSON passing the config validator),
  # there seem to be some issues with JSON in the final build - potentially due to
  # the way the client parses things
  # - Instead, we use `remarshal` to convert it to yaml
  # Config validation needs to happen after yarnConfigHook, since it's what sets the yarn offline cache
  preBuild = lib.optional (settings != { }) ''
    echo "Writing settings override..."
    json2yaml '${builtins.toFile "conf.json" (builtins.toJSON settings)}' user-data/conf.yml
    yarn validate-config --offline
  '';
  installPhase = ''
    mkdir $out
    cp -R dist/* $out
  '';

  nativeBuildInputs = [
    # This is required to fully pin the NodeJS version, since yarn*Hooks pull in the latest LTS in nixpkgs
    # The yarn override is the only one technically required (fixup-yarn-lock and prefetch-yarn-deps' node version doesn't affect the end result),
    # but they've been overridden for the sake of consistency/in case future updates to dashy/node would cause issues with differing major versions
    (yarnConfigHook.override {
      fixup-yarn-lock = fixup-yarn-lock.override {
        nodejs-slim = nodejs-slim_20;
      };
      prefetch-yarn-deps = prefetch-yarn-deps.override {
        nodejs-slim = nodejs-slim_20;
      };
      yarn = yarn.override {
        nodejs = nodejs_20;
      };
    })
    yarnBuildHook
    nodejs_20
    # For yaml conversion
    remarshal_0_17
  ];
  doDist = false;
  meta = {
    description = "Open source, highly customizable, easy-to-use, privacy-respecting dashboard app";
    homepage = "https://dashy.to";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.therealgramdalf ];
  };
})
