{
  buildGoModule,
  fetchFromGitHub,
  fetchPnpmDeps,
  lib,
  nixosTests,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  stdenvNoCC,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "stash";
  version = "0.32.0";
  appDate = "2026-11-02 16:51:05";
  gitHash = "9e9ad972";

  src = fetchFromGitHub {
    owner = "stashapp";
    repo = "stash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sRyS/ZIjBUakZQGqrjR1v2D0tk3/gIcZgXNccO/RSJ8=";
  };

  vendorHash = "sha256-1PvnJqHs3SWuInjAtrHx2lXGfw88iyqMsy12BhbgKUQ=";

  ldflags = [
    "-s"
    "-X 'github.com/stashapp/stash/internal/build.buildstamp=${finalAttrs.appDate}'"
    "-X 'github.com/stashapp/stash/internal/build.githash=${finalAttrs.gitHash}'"
    "-X 'github.com/stashapp/stash/internal/build.version=${finalAttrs.src.tag}'"
    "-X 'github.com/stashapp/stash/internal/build.officialBuild=false'"
  ];

  tags = [
    "sqlite_stat4"
    "sqlite_math_functions"
  ];

  subPackages = [ "cmd/stash" ];

  postConfigure = ''
    cp -a ${finalAttrs.passthru.frontend} ui/v2.5/build
    # `go mod tidy` requires internet access and does nothing
    echo "skip_mod_tidy: true" >> gqlgen.yml
    go generate ./cmd/stash
  '';

  passthru = {
    frontend = stdenvNoCC.mkDerivation (finalAttrs': {
      pname = "${finalAttrs.pname}-ui";
      inherit (finalAttrs)
        version
        appDate
        gitHash
        src
        ;
      sourceRoot = "${finalAttrs'.src.name}/ui/v2.5";

      pnpmDeps = fetchPnpmDeps {
        inherit (finalAttrs')
          pname
          version
          src
          sourceRoot
          ;
        pnpm = pnpm_10;
        fetcherVersion = 4;
        hash = "sha256-PkBQH3MNIpqivdXBBimkjHlfj48MdeAzqPfaRyF8ekg=";
      };

      nativeBuildInputs = [
        nodejs
        pnpmConfigHook
        pnpm_10
      ];

      postPatch = ''
        substituteInPlace codegen.ts \
          --replace-fail "../../graphql/" "${finalAttrs'.src}/graphql/"
      '';

      buildPhase = ''
        runHook preBuild

        export VITE_APP_DATE='${finalAttrs'.appDate}'
        export VITE_APP_GITHASH=${finalAttrs'.gitHash}
        export VITE_APP_STASH_VERSION=${finalAttrs'.src.tag}
        export VITE_APP_NOLEGACY=true

        pnpm run gqlgen
        pnpm run build

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mv build $out

        runHook postInstall
      '';

      dontFixup = true;
    });

    tests = {
      inherit (nixosTests) stash;
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        version = "${finalAttrs.src.tag} (${finalAttrs.gitHash}) - Unofficial Build - ${finalAttrs.appDate}";
      };
    };

    updateScript = ./update.sh;
  };

  meta = {
    mainProgram = "stash";
    description = "Organizer for your adult videos/images";
    license = lib.licenses.agpl3Only;
    homepage = "https://stashapp.cc/";
    changelog = "https://github.com/stashapp/stash/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [
      DrakeTDL
      a4blue
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
