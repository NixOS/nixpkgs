{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  callPackage,
  nodejs_24,
  ffmpeg_8-full,
  nunicode,
  util-linux,
  python3,
  typescript_5,
  jq,
  nixosTests,
  nix-update-script,
  routerBasePath ? "/audiobookshelf",
}:

let
  nodejs = nodejs_24;
in
buildNpmPackage (finalAttrs: {
  pname = "audiobookshelf";
  version = "2.37.1";

  src = fetchFromGitHub {
    owner = "advplyr";
    repo = "audiobookshelf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rTn64PrGPSKwDbsQmzvdSRa7UQEV1f2xXaYGtcVfrpk=";
  };

  npmDepsHash = "sha256-xHjZ3E1DGeb5NueP67hEX3vHH0Qlk4LTeZkMEFBhGyE=";

  inherit nodejs;

  buildInputs = [ util-linux ];
  nativeBuildInputs = [
    python3
    typescript_5
    jq
  ];

  npmBuildScript = "build:server";
  npmInstallFlags = [ "--omit=dev" ];

  makeWrapperArgs = [
    "--set"
    "FFMPEG_PATH"
    (lib.getExe ffmpeg_8-full)
    "--set"
    "FFPROBE_PATH"
    (lib.getExe' ffmpeg_8-full "ffprobe")
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
    changelog = "https://github.com/advplyr/audiobookshelf/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      jvanbruegge
      adamcstephens
      tebriel
      connor-grady
    ];
    platforms = lib.platforms.linux;
    mainProgram = "audiobookshelf";
  };
})
