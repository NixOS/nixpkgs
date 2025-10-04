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
in
buildGoModule (
  finalAttrs:
  let
    frontend = stdenv.mkDerivation (final: {
      pname = "${finalAttrs.pname}-ui";
      inherit (finalAttrs) version gitHash;
      src = "${finalAttrs.src}/ui/v2.5";

      yarnOfflineCache = fetchYarnDeps {
        yarnLock = "${final.src}/yarn.lock";
        hash = finalAttrs.yarnHash;
      };

      nativeBuildInputs = [
        yarnConfigHook
        yarnBuildHook
        # Needed for executing package.json scripts
        nodejs
      ];

      postPatch = ''
        substituteInPlace codegen.ts \
          --replace-fail "../../graphql/" "${finalAttrs.src}/graphql/"
      '';

      buildPhase = ''
        runHook preBuild

        export HOME=$(mktemp -d)
        export VITE_APP_DATE='1970-01-01 00:00:00'
        export VITE_APP_GITHASH=${finalAttrs.gitHash}
        export VITE_APP_STASH_VERSION=v${finalAttrs.version}
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
  {
    inherit
      pname
      version
      gitHash
      yarnHash
      vendorHash
      ;

    src = fetchFromGitHub {
      owner = "stashapp";
      repo = "stash";
      tag = "v${finalAttrs.version}";
      hash = srcHash;
    };

    ldflags = [
      "-s"
      "-w"
      "-X 'github.com/stashapp/stash/internal/build.buildstamp=1970-01-01 00:00:00'"
      "-X 'github.com/stashapp/stash/internal/build.githash=${finalAttrs.gitHash}'"
      "-X 'github.com/stashapp/stash/internal/build.version=v${finalAttrs.version}'"
      "-X 'github.com/stashapp/stash/internal/build.officialBuild=false'"
    ];
    tags = [
      "sqlite_stat4"
      "sqlite_math_functions"
    ];

    subPackages = [ "cmd/stash" ];

    postPatch = ''
      cp -a ${frontend} ui/v2.5/build
    '';

    preBuild = ''
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
          version = "v${finalAttrs.version} (${finalAttrs.gitHash}) - Unofficial Build - 1970-01-01 00:00:00";
        };
      };
    };

    meta = {
      mainProgram = "stash";
      description = "Organizer for your adult videos/images";
      license = lib.licenses.agpl3Only;
      homepage = "https://stashapp.cc/";
      changelog = "https://github.com/stashapp/stash/blob/v${finalAttrs.version}/ui/v2.5/src/docs/en/Changelog/v${lib.versions.major finalAttrs.version}${lib.versions.minor finalAttrs.version}0.md";
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
)
