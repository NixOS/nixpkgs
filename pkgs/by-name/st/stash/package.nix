{
  lib,
  buildGoModule,
  callPackage,
  darwin,
  fetchFromGitHub,
  fetchYarnDeps,
  mkYarnPackage,
  nixosTests,
  stdenv,
  testers,
}:
let
  inherit (lib.importJSON ./version.json)
    stamp
    version
    gitHash
    srcHash
    yarnHash
    ;

  pname = "stash";

  src = fetchFromGitHub {
    owner = "stashapp";
    repo = pname;
    rev = "v${version}";
    hash = srcHash;
  };

  uiSrc = "${src}/ui/v2.5";

  ui = mkYarnPackage {
    inherit version;
    pname = "${pname}-ui";
    src = uiSrc;

    packageJSON = ./package.json;

    offlineCache = fetchYarnDeps {
      yarnLock = "${uiSrc}/yarn.lock";
      hash = yarnHash;
    };

    postPatch = ''substituteInPlace codegen.ts --replace "../../graphql/" "${src}/graphql/"'';

    configurePhase = ''ln -s $node_modules node_modules'';

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      export VITE_APP_DATE='${stamp}'
      export VITE_APP_GITHASH=${gitHash}
      export VITE_APP_STASH_VERSION=v${version}
      export VITE_APP_NOLEGACY=true

      yarn --offline run gqlgen
      yarn --offline build

      mv build $out

      runHook postBuild
    '';

    distPhase = "true";
    dontInstall = true;
    dontFixup = true;
  };

  goVendor = (callPackage (import ./buildGoVendor.nix) { inherit pname src; }).goModules;
in
(buildGoModule {
  inherit pname version src;

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/stashapp/stash/internal/build.buildstamp=${stamp}'"
    "-X 'github.com/stashapp/stash/internal/build.githash=${gitHash}'"
    "-X 'github.com/stashapp/stash/internal/build.version=v${version}'"
    "-X 'github.com/stashapp/stash/internal/build.officialBuild=true'"
  ];
  tags = [ "sqlite_stat4" ];

  subPackages = [ "cmd/stash" ];

  buildInputs = lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      Cocoa
      WebKit
    ]
  );

  postConfigure = ''ln -s ${goVendor} vendor'';

  preBuild = ''
    cp -a ${ui} ui/v2.5/build
    # `go mod tidy` requires internet access and does nothing
    echo "skip_mod_tidy: true" >> gqlgen.yml
    # remove `-trimpath` fron `GOFLAGS` because `gqlgen` does not work with it
    GOFLAGS="''${GOFLAGS/-trimpath/}" go generate ./cmd/stash
  '';

  strictDeps = true;

  meta = with lib; {
    mainProgram = "stash";
    description = "An organizer for your adult videos, written in Go.";
    license = licenses.agpl3Only;
    homepage = "https://stashapp.cc/";
    changelog =
      let
        major = versions.major version;
        minor = versions.minor version;
        changelogFile = "v${major}${minor}0.md";
      in
      "https://github.com/stashapp/stash/blob/v${version}/ui/v2.5/src/docs/en/Changelog/${changelogFile}";
    maintainers = with maintainers; [
      Golo300
      DrakeTDL
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
    ];
  };
}).overrideAttrs
  (
    final: prev: {
      passthru = {
        updateScript = ./update.nu;

        tests = {
          stash = nixosTests.stash;
          version = testers.testVersion {
            package = final.finalPackage;
            version = "v${version} (${gitHash}) - Official Build - ${stamp}";
          };
        };
      };
    }
  )
