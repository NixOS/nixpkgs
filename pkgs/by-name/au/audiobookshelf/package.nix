{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  buildNpmPackage,
  nodejs_18,
  ffmpeg-full,
  util-linux,
  python3,
  getopt,
  nixosTests,
}:

let
  nodejs = nodejs_18;

  source = builtins.fromJSON (builtins.readFile ./source.json);
  pname = "audiobookshelf";

  src = fetchFromGitHub {
    owner = "advplyr";
    repo = "audiobookshelf";
    rev = "refs/tags/v${source.version}";
    inherit (source) hash;
  };

  client = buildNpmPackage {
    pname = "audiobookshelf-client";
    inherit (source) version;

    src = runCommand "cp-source" { } ''
      cp -r ${src}/client $out
    '';

    # don't download the Cypress binary
    CYPRESS_INSTALL_BINARY = 0;
    NODE_OPTIONS = "--openssl-legacy-provider";

    npmBuildScript = "generate";
    npmDepsHash = source.clientDepsHash;
  };

  wrapper = import ./wrapper.nix {
    inherit
      stdenv
      ffmpeg-full
      pname
      nodejs
      getopt
      ;
  };

in
buildNpmPackage {
  inherit pname src;
  inherit (source) version;

  postPatch = ''
    # Always skip version checks of the binary manager.
    # We provide our own binaries, and don't want to trigger downloads.
    substituteInPlace server/managers/BinaryManager.js --replace-fail \
      'if (!this.validVersions.length) return true' \
      'return true'
  '';

  buildInputs = [ util-linux ];
  nativeBuildInputs = [ python3 ];

  dontNpmBuild = true;
  npmInstallFlags = [ "--only-production" ];
  npmDepsHash = source.depsHash;

  installPhase = ''
    mkdir -p $out/opt/client
    cp -r index.js server package* node_modules $out/opt/
    cp -r ${client}/lib/node_modules/audiobookshelf-client/dist $out/opt/client/dist
    mkdir $out/bin

    echo '${wrapper}' > $out/bin/audiobookshelf
    echo "  exec ${nodejs}/bin/node $out/opt/index.js" >> $out/bin/audiobookshelf

    chmod +x $out/bin/audiobookshelf
  '';

  passthru = {
    tests.basic = nixosTests.audiobookshelf;
    updateScript = ./update.nu;
  };

  meta = {
    homepage = "https://www.audiobookshelf.org/";
    description = "Self-hosted audiobook and podcast server";
    changelog = "https://github.com/advplyr/audiobookshelf/releases/tag/v${source.version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      jvanbruegge
      adamcstephens
    ];
    platforms = lib.platforms.linux;
    mainProgram = "audiobookshelf";
  };
}
