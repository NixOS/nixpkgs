{
  lib,
  stdenv,
  fetchFromGitHub,
  jq,
  fetchYarnDeps,

  yarnConfigHook,
  yarnBuildHook,
  npmHooks,
  nodejs,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "awk-language-server";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "Beaglefoot";
    repo = "awk-language-server";
    tag = "server-${finalAttrs.version}";
    hash = "sha256-YtduDfMAUAoQY9tgyhgERFwx9TEgD52KdeHnX2MrjjI=";
    sparseCheckout = [ "server" ];
    postFetch = ''
      # combine both yarn lock files
      tail -n+4 $out/server/yarn.lock >> $out/yarn.lock

      # recontextualize server/package.json to be one folder up
      sed -i 's|\./|./server/|' $out/server/package.json

      # combine both package.json files
      ${lib.getExe jq} -s '.[0] * .[1]' \
        $out/server/package.json \
        $out/package.json \
        > package.json
      mv -f package.json $out/
    '';
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-PaebqpXQGBxqcaxun8zi6TPeIgHmY+2fjsE/3LaWPN8=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    npmHooks.npmInstallHook
    nodejs
  ];

  yarnBuildScript = "build:server";
  dontNpmPrune = true;

  meta = {
    description = "Language Server for AWK and associated VSCode client extension";
    homepage = "https://github.com/Beaglefoot/awk-language-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mathiassven ];
    mainProgram = "awk-language-server";
  };
})
