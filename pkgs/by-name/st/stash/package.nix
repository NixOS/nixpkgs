{
  buildGoModule,
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  nixosTests,
  nodejs,
  stash,
  stdenv,
  testers,
  yarnBuildHook,
  yarnConfigHook,
}:
let
  inherit (lib.importJSON ./version.json)
    gitHash
    srcHash
    vendorHash
    version
    yarnHash
    ;

  pname = "stash";

  src = fetchFromGitHub {
    owner = "stashapp";
    repo = "stash";
    tag = "v${version}";
    hash = srcHash;
  };

  frontend = stdenv.mkDerivation (final: {
    inherit version;
    pname = "${pname}-ui";
    src = "${src}/ui/v2.5";

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = "${final.src}/yarn.lock";
      hash = yarnHash;
    };

    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook
      # Needed for executing package.json scripts
      nodejs
    ];

    postPatch = ''
      substituteInPlace codegen.ts \
        --replace-fail "../../graphql/" "${src}/graphql/"
    '';

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      export VITE_APP_DATE='1970-01-01 00:00:00'
      export VITE_APP_GITHASH=${gitHash}
      export VITE_APP_STASH_VERSION=v${version}
      export VITE_APP_NOLEGACY=true

      yarn --offline run gqlgen
      yarn --offline build

      mv build $out

      runHook postBuild
    '';

    dontInstall = true;
    dontFixup = true;
  });
in
buildGoModule {
  inherit
    pname
    src
    version
    vendorHash
    ;

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/stashapp/stash/internal/build.buildstamp=1970-01-01 00:00:00'"
    "-X 'github.com/stashapp/stash/internal/build.githash=${gitHash}'"
    "-X 'github.com/stashapp/stash/internal/build.version=v${version}'"
    "-X 'github.com/stashapp/stash/internal/build.officialBuild=false'"
  ];
  tags = [
    "sqlite_stat4"
    "sqlite_math_functions"
  ];

  subPackages = [ "cmd/stash" ];

  preBuild = ''
    cp -a ${frontend} ui/v2.5/build
    # `go mod tidy` requires internet access and does nothing
    echo "skip_mod_tidy: true" >> gqlgen.yml
    # remove `-trimpath` fron `GOFLAGS` because `gqlgen` does not work with it
    GOFLAGS="''${GOFLAGS/-trimpath/}" go generate ./cmd/stash
  '';

  strictDeps = true;

  passthru = {
    inherit frontend;
    updateScript = ./update.py;
    tests = {
      inherit (nixosTests) stash;
      version = testers.testVersion {
        package = stash;
        version = "v${version} (${gitHash}) - Unofficial Build - 1970-01-01 00:00:00";
      };
    };
  };

  meta = {
    mainProgram = "stash";
    description = "Organizer for your adult videos/images";
    license = lib.licenses.agpl3Only;
    homepage = "https://stashapp.cc/";
    changelog = "https://github.com/stashapp/stash/blob/v${version}/ui/v2.5/src/docs/en/Changelog/v${lib.versions.major version}${lib.versions.minor version}0.md";
    maintainers = with lib.maintainers; [
      Golo300
      DrakeTDL
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
