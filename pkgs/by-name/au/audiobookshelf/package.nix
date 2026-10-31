{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  buildPackages,
  callPackage,
  nodejs_24,
  nodejs-slim_24,
  ffmpeg_8-headless,
  nunicode,
  sqlite,
  typescript_5,
  jq,
  nixosTests,
  nix-update-script,
  routerBasePath ? "/audiobookshelf",
}:

buildNpmPackage (finalAttrs: {
  pname = "audiobookshelf";
  version = "2.37.2";

  src = fetchFromGitHub {
    owner = "advplyr";
    repo = "audiobookshelf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GnXWG+8tb/clX6rpw4x1c5Usl28jKLEhuMFiAG+fCec=";
  };

  npmDepsHash = "sha256-wF3PMYN+nymE6VktHtKcdLhSkeE4e04nGcRQJhYHG4c=";

  nodejs = nodejs_24;

  nativeBuildInputs = [
    typescript_5
    jq
  ];

  buildInputs = [
    nodejs-slim_24
    sqlite
  ];

  inherit (buildPackages.npmHooks.override { nodejs = nodejs-slim_24; }) npmInstallHook;

  npmInstallFlags = [
    "--omit=dev"
    "--omit=optional"
  ];
  npmRebuildFlags = [ "--sqlite=${lib.getDev sqlite}" ];
  npmBuildScript = "build:server";

  makeWrapperArgs = [
    "--set"
    "FFMPEG_PATH"
    (lib.getExe ffmpeg_8-headless)
    "--set"
    "FFPROBE_PATH"
    (lib.getExe' ffmpeg_8-headless "ffprobe")
    "--set"
    "NODE_ENV"
    "production"
    "--set"
    "NUSQLITE3_PATH"
    "${nunicode.sqlite}/lib/libnusqlite3"
    "--set"
    "ROUTER_BASE_PATH"
    (lib.escapeShellArg routerBasePath)
    "--set"
    "SKIP_BINARIES_CHECK"
    "1"
    "--set"
    "SOURCE"
    "nixpkgs"
  ];

  preInstall = ''
    rm -r \
      node_modules/{.bin,@types} \
      node_modules/sqlite3/{binding.gyp,deps,src} \
      node_modules/sqlite3/build/{Makefile,binding.Makefile,config.gypi,node_sqlite3.target.mk} \
      node_modules/sqlite3/build/Release/{.deps,obj.target}

    shopt -s globstar
    rm node_modules/**/*.{map,ts,mts,cts}
    shopt -u globstar

    patchShebangs --host --update node_modules
  '';

  installPhase = ''
    runHook preInstall

    packageOut="$out/lib/node_modules/$(jq --raw-output '.name' package.json)"

    mkdir -p "$packageOut"/{client,dist-server}
    cp -r dist-server/{index.js,package.json,server} "$packageOut"/dist-server/
    cp -r node_modules package.json "$packageOut"/
    cp -r ${finalAttrs.passthru.client} "$packageOut"/client/dist

    nodejsInstallExecutables

    runHook postInstall
  '';

  disallowedReferences = [ finalAttrs.nodejs ];

  passthru = {
    client = callPackage ./client.nix {
      inherit (finalAttrs) src version nodejs;
      inherit routerBasePath;
    };
    tests.basic = nixosTests.audiobookshelf;
    updateScript = nix-update-script { extraArgs = [ "--subpackage=client" ]; };
  };

  meta = {
    homepage = "https://www.audiobookshelf.org/";
    description = "Self-hosted audiobook and podcast server";
    changelog = "https://github.com/advplyr/audiobookshelf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      jvanbruegge
      adamcstephens
      tebriel
      connor-grady
    ];
    platforms = lib.platforms.linux;
    mainProgram = "audiobookshelf";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
})
