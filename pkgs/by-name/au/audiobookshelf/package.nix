{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  buildNpmPackage,
  nodejs,
  ffmpeg-full,
  nunicode,
  util-linux,
  python3,
  getopt,
  nixosTests,
}:

let
  source = {
    version = "2.30.0";
    hash = "sha256-4nmKTB/EUiyoOzti0BjbKrfnu3CA9XJnekgxFporVyI=";
    npmDepsHash = "sha256-apr7s6GeYAAYg5n9gJjG9MVRPXJnpJoIvVyyAFw3Als=";
    clientNpmDepsHash = "sha256-+yDIgQENUmUcxytym8Ke4M6CJ915BvdhgtQFc+ykiD8=";
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
    echo "  exec ${nodejs}/bin/node $out/opt/index.js" >> $out/bin/audiobookshelf

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
