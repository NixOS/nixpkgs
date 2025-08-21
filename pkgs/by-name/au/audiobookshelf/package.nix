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
    version = "2.28.0";
    hash = "sha256-bbsiaSGIaD5oFnhk3e+SWzYxv4dsRXrgMVbe1lsj4pw=";
    npmDepsHash = "sha256-JC2uOXV+EwS6CGwyOUTXcymFwLSz/KUqIoB4ccSGgbw=";
    clientNpmDepsHash = "sha256-6l8apOd3R259+SlcD6P6rx1FkRnB80keoBGcfbQNhGU=";
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
