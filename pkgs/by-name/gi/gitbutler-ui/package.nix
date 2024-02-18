{ lib
, mkYarnPackage
, fetchYarnDeps
, fetchFromGitHub
}:

mkYarnPackage rec {
  pname = "gitbutler-ui";
  version = "0.10.10";

  src = fetchFromGitHub {
    owner = "gitbutlerapp";
    repo = "gitbutler";
    rev = "release/${version}";
    hash = "sha256-DutsgMlYBITzD65Zbq1OlbmY20RogogN57flGn9x06c=";
  };

  sourceRoot = "${src.name}/gitbutler-ui";

  # To generate the Yarn lockfile, run `yarn install`.
  # There is no way to import the tagged pnpm lockfile, so make sure to test the
  # result thoughly as dependency versions may differ from the release.
  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  offlineCache = fetchYarnDeps {
    inherit yarnLock;
    hash = "sha256-ZN0vMus7iuXsjnq9d+egDQAg54aJl0v85dicVhE1MQI=";
  };

  preConfigure = ''
    chmod u+w -R "$NIX_BUILD_TOP"
  '';

  buildPhase = ''
    runHook preBuild

    export HOME="$(mktemp -d)"
    yarn --offline prepare
    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r deps/@gitbutler/ui/build "$out"

    runHook postInstall
  '';

  distPhase = "true";

  meta = rec {
    description = "The UI for GitButler.";
    homepage = "https://gitbutler.com";
    downloadPage = homepage;
    changelog = "https://github.com/gitbutlerapp/gitbutler/releases/tag/release/${version}";
    license = {
      fullName = "Functional Source License, Version 1.0, MIT Change License";
      url = "https://github.com/gitbutlerapp/gitbutler/blob/master/LICENSE.md";
      free = false;
    };
    maintainers = with lib.maintainers; [ hacker1024 ];
    platforms = with lib.platforms; all;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
