{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  buildNpmPackage,
  nodejs_22,
  ffmpeg-full,
  nunicode,
  util-linux,
  python3,
  getopt,
  nixosTests,
}:

let
  source = {
    version = "2.32.1";
    hash = "sha256-OABIRUVOLGt2Xj//u/GbzS9+Jxn4jI38FE1vsuyb5xw=";
    npmDepsHash = "sha256-kDq4k9iVuWo8+wdm1K/Ufz9vFIQD4ERHTsBXwtp9+Yc=";
    clientNpmDepsHash = "sha256-1O1f+Mg7f2nzmGQytzQdalDV2C4o5EBkuqtTCKpmiN8=";
  };

  src = fetchFromGitHub {
    owner = "advplyr";
    repo = "audiobookshelf";
    tag = "v${source.version}";
    inherit (source) hash;
  };

  client = buildNpmPackage {
    pname = "audiobookshelf-client";
    inherit (source) version;

    nodejs = nodejs_22;

    src = runCommand "cp-source" { } ''
      cp -r ${src}/client $out
    '';

    # don't download the Cypress binary
    CYPRESS_INSTALL_BINARY = 0;
    NODE_OPTIONS = "--openssl-legacy-provider";

    npmBuildScript = "generate";
    npmDepsHash = source.clientNpmDepsHash;
  };

  wrapper = import ./wrapper.nix {
    inherit
      stdenv
      ffmpeg-full
      nunicode
      getopt
      ;
  };

in
buildNpmPackage {
  pname = "audiobookshelf";

  inherit src;
  inherit (source) npmDepsHash version;
  nodejs = nodejs_22;

  buildInputs = [ util-linux ];
  nativeBuildInputs = [ python3 ];

  dontNpmBuild = true;
  npmInstallFlags = [ "--only-production" ];

  installPhase = ''
    mkdir -p $out/opt/client
    cp -r index.js server package* node_modules $out/opt/
    cp -r ${client}/lib/node_modules/audiobookshelf-client/dist $out/opt/client/dist
    mkdir $out/bin

    echo '${wrapper}' > $out/bin/audiobookshelf
    echo "  exec ${nodejs_22}/bin/node $out/opt/index.js" >> $out/bin/audiobookshelf

    chmod +x $out/bin/audiobookshelf
  '';

  passthru = {
    tests.basic = nixosTests.audiobookshelf;
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://www.audiobookshelf.org/";
    description = "Self-hosted audiobook and podcast server";
    changelog = "https://github.com/advplyr/audiobookshelf/releases/tag/v${source.version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      jvanbruegge
      adamcstephens
      tebriel
    ];
    platforms = lib.platforms.linux;
    mainProgram = "audiobookshelf";
  };
}
