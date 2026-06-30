{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
  nodejs,
  stash,
  stdenv,
  testers,
  fetchPnpmDeps,
  pnpm_10,
  pnpmConfigHook,
  buildNpmPackage,
}:
let
  gitHash = "4de2351e";
  srcHash = "sha256-YGWf2aJaVn2kdICkFhvaoPq0OW+jHF8IgLLf8/duqIo=";
  vendorHash = "sha256-jv93Pkn8UqasHK4QyyU9u+S6g9/fLNHK72/h92OB/rg=";
  pname = "stash";
  version = "0.31.1";
  pnpmHash = "sha256-l7vQnLsroPCbbYWOdj+w9+1FegVCjdojGM8C5gOO9c8=";
  appDate = "2026-04-13 03:03:09";

  src = fetchFromGitHub {
    owner = "stashapp";
    repo = "stash";
    tag = "v${version}";
    hash = srcHash;
  };
  frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "${pname}-ui";
    inherit version src;
    sourceRoot = "${src.name}/ui/v2.5";

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs)
        pname
        version
        src
        sourceRoot
        ;
      fetcherVersion = 3;
      hash = "sha256-l7vQnLsroPCbbYWOdj+w9+1FegVCjdojGM8C5gOO9c8=";
      pnpm = pnpm_10;
    };

    strictDeps = true;
    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_10
    ];

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      export VITE_APP_DATE='${appDate}'
      export VITE_APP_GITHASH=${gitHash}
      export VITE_APP_STASH_VERSION=v${version}
      export VITE_APP_NOLEGACY=true

      npm run gqlgen
      npm run build

      mv build $out

      runHook postBuild
    '';

    postPatch = ''
      substituteInPlace codegen.ts \
        --replace-fail "../../graphql/" "${finalAttrs.src}/graphql/"
    '';
  });
in
buildGoModule (finalAttrs: {
  inherit
    pname
    version
    gitHash
    pnpmHash
    vendorHash
    src
    ;

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/stashapp/stash/internal/build.buildstamp=${appDate}'"
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

  proxyVendor = true;

  passthru = {
    inherit frontend;
    tests = {
      inherit (nixosTests) stash;
      version = testers.testVersion {
        package = stash;
        version = "v${finalAttrs.version} (${finalAttrs.gitHash}) - Unofficial Build - ${appDate}";
      };
    };
    updateScript.command = [ ./update.sh ];
  };

  meta = {
    mainProgram = "stash";
    description = "Organizer for your adult videos/images";
    license = lib.licenses.agpl3Only;
    homepage = "https://stashapp.cc/";
    changelog = "https://github.com/stashapp/stash/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      DrakeTDL
      a4blue
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
