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
  src = fetchFromGitHub {
    owner = "stashapp";
    repo = "stash";
    tag = "v${version}";
    hash = srcHash;
  };

  pname = "stash";
  version = "0.30.1";
  gitHash = "b23b0267adc668bb22390ccc5772e75946aed492";
  srcHash = "sha256-d/cfU7L7UDuVHhss4QJYgdBY+nnoxR7jaVk29uaDILE=";

  vendorHash = "sha256-HuEXU0r422ptGpf4d1b00g1ZRDbcgfsSDou4o07NmKY=";

  frontend = buildNpmPackage rec {
    pname = "stash-ui";
    inherit version src;

    sourceRoot = "${src.name}/ui/v2.5";

    pnpmDeps = fetchPnpmDeps {
      inherit
        pname
        version
        src
        sourceRoot
        ;
      fetcherVersion = 3;
      hash = "sha256-TisTXUSjxkPOGy7E6LSiK05GZFQL6UG+OKg1OHX/Zyk=";
    };
    npmConfigHook = pnpmConfigHook;
    npmDeps = pnpmDeps;

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_10
    ];

    installPhase = ''
      runHook preInstall

      mkdir $out
      mv dist $out

      runHook postInstall
    '';

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

              npm run gqlgen
              npm run build

              mv build $out

              runHook postBuild
    '';

    dontInstall = true;
    dontFixup = true;
  };
in
buildGoModule {
  inherit
    pname
    version
    gitHash
    vendorHash
    src
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
  proxyVendor = true;

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
