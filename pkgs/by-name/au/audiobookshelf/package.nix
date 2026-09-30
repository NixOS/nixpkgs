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
  version = "2.37.0";

  src = fetchFromGitHub {
    owner = "advplyr";
    repo = "audiobookshelf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zo9xByg1QMdqfy161rnmfJ0Mt5CJvKbZIMijj2kQpQM=";
  };

  npmDepsHash = "sha256-S9RGAc5ge+ULtRMbiY1ZOaxY5Ra2ltZdCHcGbkhUxzs=";

  inherit nodejs;

  buildInputs = [ util-linux ];
  nativeBuildInputs = [ python3 ];

  dontNpmBuild = true;
  npmInstallFlags = [ "--only-production" ];

  client = callPackage ./client.nix { inherit (finalAttrs) src version nodejs; };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/client
    cp -r index.js server package* node_modules $out/opt/
    cp -r ${finalAttrs.client}/lib/node_modules/audiobookshelf-client/dist $out/opt/client/dist
    mkdir $out/bin

    echo '${wrapper}' > $out/bin/audiobookshelf
    echo "  exec ${finalAttrs.nodejs}/bin/node $out/opt/index.js" >> $out/bin/audiobookshelf

    chmod +x $out/bin/audiobookshelf

    runHook postInstall
  '';

  passthru = {
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
    ];
    platforms = lib.platforms.linux;
    mainProgram = "audiobookshelf";
  };
})
