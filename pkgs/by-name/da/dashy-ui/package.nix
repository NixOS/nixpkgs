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
  nodejs_24,
  nodejs-slim_24,
  remarshal,
  nix-update-script,
  settings ? { },
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dashy-ui";
  version = "4.6.0";
  src = fetchFromGitHub {
    owner = "lissy93";
    repo = "dashy";
    tag = finalAttrs.version;
    hash = "sha256-fU8sbxaHs+j2Z/+xvE6w8qBF2cxKtRx+ARQlpfJ2n5Y=";
  };
  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-EBtJW3atTgLeLn+PLxePmrnEG9Xl0R+9LIlTh+Vgw5g=";
  };

  passthru = {
    tests.dashy = nixosTests.dashy;
    updateScript = nix-update-script { };
  };

  # - If no settings are passed, use the default config provided by upstream
  # - Despite JSON being valid YAML (and the JSON passing the config validator),
  # there seem to be some issues with JSON in the final build - potentially due to
  # the way the client parses things
  # - Instead, we use `remarshal` to convert it to yaml
  # Config validation needs to happen after yarnConfigHook, since it's what sets the yarn offline cache
  preBuild = lib.optionalString (settings != { }) ''
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
        nodejs-slim = nodejs-slim_24;
      };
      prefetch-yarn-deps = prefetch-yarn-deps.override {
        nodejs-slim = nodejs-slim_24;
      };
      yarn = yarn.override {
        nodejs = nodejs_24;
      };
    })
    yarnBuildHook
    nodejs_24
    # For yaml conversion
    remarshal
  ];
  doDist = false;
  meta = {
    description = "Open source, highly customizable, easy-to-use, privacy-respecting dashboard app";
    homepage = "https://dashy.to";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.therealgramdalf ];
  };
})
