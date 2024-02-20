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

  # The package.json comes from the gitbutler-ui directory, and must use spaces
  # instead of upstream's tabs to pass Nixpkgs CI.
  #
  # To generate the Yarn lockfile, run:
  # pnpm-lock-export --schema yarn.lock@v1 < pnpm-lock.yaml
  # Then, fix Git dependencies, e.g. "tauri-plugin-store-api@0.0.0" -> "tauri-plugin-store-api@github:tauri-apps/tauri-plugin-store#v1".
  # Remove any 'integrity "undefined"' lines as well.
  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  offlineCache = fetchYarnDeps {
    inherit yarnLock;
    hash = "sha256-5QBWzAtFXhSVJUalmLa2Wq8DH/D4ZB/7DPR0VeWf0wg=";
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
      redistributable = true;
    };
    maintainers = with lib.maintainers; [ hacker1024 ];
    platforms = with lib.platforms; all;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
