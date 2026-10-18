{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  callPackage,
  nodejs_24,
  ffmpeg_8-full,
  nunicode,
  util-linux,
  python3,
  typescript_5,
  getopt,
  nixosTests,
  nix-update-script,
}:

let
  ffmpeg-full = ffmpeg_8-full;
  nodejs = nodejs_24;

  wrapper = import ./wrapper.nix {
    inherit
      stdenv
      ffmpeg-full
      nunicode
      getopt
      ;
  };
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
  ];

  npmBuildScript = "build:server";
  npmInstallFlags = [ "--omit=dev" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/{client,dist-server}
    cp -r dist-server/{index.js,package.json,server} $out/opt/dist-server/
    cp -r node_modules package.json $out/opt/
    cp -r ${finalAttrs.passthru.client} $out/opt/client/dist
    mkdir $out/bin

    echo '${wrapper}' > $out/bin/audiobookshelf
    echo "  exec ${finalAttrs.nodejs}/bin/node $out/opt/dist-server/index.js" >> $out/bin/audiobookshelf

    chmod +x $out/bin/audiobookshelf

    runHook postInstall
  '';

  passthru = {
    client = callPackage ./client.nix { inherit (finalAttrs) src version nodejs; };
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
