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
  nodejs_20,
  nodejs-slim_20,
  yq-go,
  settings ? { },
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dashy-ui";
  # This is like 3.1.1 but the latest working yarn.lock.
  # All other changes are for docs with the exception of 768d746cbfcf365c58ad1194c5ccc74c14f3ed3a, which simply adds no-referrer meta tag
  version = "3.1.1-unstable-2024-07-14";
  src = fetchFromGitHub {
    owner = "lissy93";
    repo = "dashy";
    rev = "0b1af9db483f80323e782e7834da2a337393e111";
    hash = "sha256-lRJ3lI9UUIaw9GWPEy81Dbf4cu6rClA4VjdWejVQN+g=";
  };
  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-KVAZIBM47yp1NWYc2esvTwfoAev4q7Wgi0c73PUZRNw=";
  };
  # - If no settings are passed, use the default config provided by upstream
  # - Despite JSON being valid YAML (and the JSON passing the config validator),
  # there seem to be some issues with JSON in the final build - potentially due to
  # the way the client parses things
  # - Instead, we use `yq-go` to convert it to yaml
  # Config validation needs to happen after yarnConfigHook, since it's what sets the yarn offline cache
  preBuild = lib.optional (settings != { }) ''
    echo "Writing settings override..."
    yq --output-format yml '${builtins.toFile "conf.json" ''${builtins.toJSON settings}''}' > user-data/conf.yml
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
    # For yaml parsing
    yq-go
  ];
  doDist = false;
  meta = {
    description = "dashy";
    homepage = "https://dashy.to";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.therealgramdalf ];
  };
})
