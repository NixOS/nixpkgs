{
  lib,
  mkYarnPackage,
  fetchYarnDeps,
  fetchFromGitHub,
  jq,
}:

mkYarnPackage rec {
  name = "awk-language-server";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "Beaglefoot";
    repo = "awk-language-server";
    rev = "server-${version}";
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

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;

  offlineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    hash = "sha256-PaebqpXQGBxqcaxun8zi6TPeIgHmY+2fjsE/3LaWPN8=";
  };

  distPhase = "true";

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    yarn --offline build:server

    runHook postBuild
  '';

  postInstall = ''
    chmod +x $out/bin/awk-language-server
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Language Server for AWK and associated VSCode client extension";
    homepage = "https://github.com/Beaglefoot/awk-language-server";
    license = licenses.mit;
    maintainers = with maintainers; [ mathiassven ];
    mainProgram = "awk-language-server";
  };
}
