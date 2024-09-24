{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  curl,
  openssl,
  testers,
  mongodb-ce,
  writeShellApplication,
  jq,
  nix-update,
  gitMinimal,
  pup,
}:

let
  version = "7.0.14";

  srcs = version: {
    "x86_64-linux" = {
      url = "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2204-${version}.tgz";
      hash = "sha256-tM+MquEIeFE17Mi4atjtbfXW77hLm5WlDsui/CRs4IQ=";
    };
    "aarch64-linux" = {
      url = "https://fastdl.mongodb.org/linux/mongodb-linux-aarch64-ubuntu2204-${version}.tgz";
      hash = "sha256-4XiHv6JKopZ/3xrXwT+nvQ2OsbkhL79uwBCnOOMaNlc=";
    };
    "x86_64-darwin" = {
      url = "https://fastdl.mongodb.org/osx/mongodb-macos-x86_64-${version}.tgz";
      hash = "sha256-mw9w/qz3xBVC7n0JBeL4CQsJ1bhBPwyQeUBsCa/XosA=";
    };
    "aarch64-darwin" = {
      url = "https://fastdl.mongodb.org/osx/mongodb-macos-arm64-${version}.tgz";
      hash = "sha256-iAX4szgBzQe5ARjCXlB7DeIcatQms3X75J6Jb/xXXQ4=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mongodb-ce";
  inherit version;

  src = fetchurl (
    (srcs version).${stdenv.hostPlatform.system}
      or (throw "unsupported system: ${stdenv.hostPlatform.system}")
  );

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  dontStrip = true;

  buildInputs = [
    curl.dev
    openssl.dev
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 755 bin/mongod $out/bin/mongod
    install -Dm 755 bin/mongos $out/bin/mongos

    runHook postInstall
  '';

  passthru = {

    updateScript =
      let
        script = writeShellApplication {
          name = "${finalAttrs.pname}-updateScript";

          runtimeInputs = [
            curl
            jq
            nix-update
            gitMinimal
            pup
          ];

          text =
            ''
              # Get latest version string from Github
              NEW_VERSION=$(curl -s "https://api.github.com/repos/mongodb/mongo/tags?per_page=1000" | jq -r 'first(.[] | .name | select(startswith("r7.0")) | select(contains("rc") | not) | .[1:])')

              # Check if the new version is available for download, if not, exit
              curl -s https://www.mongodb.com/try/download/community-edition/releases | pup 'h3:not([id]) text{}' | grep "$NEW_VERSION"

              if [[ "${version}" = "$NEW_VERSION" ]]; then
                  echo "The new version same as the old version."
                  exit 0
              fi
            ''
            + lib.concatStrings (
              map (system: ''
                nix-update --system ${system} --version "$NEW_VERSION" ${finalAttrs.pname}
              '') finalAttrs.meta.platforms
            );
        };
      in
      {
        command = lib.getExe script;
      };

    tests.version = testers.testVersion {
      package = mongodb-ce;
      command = "mongod --version";
    };
  };

  meta = {
    changelog = "https://www.mongodb.com/docs/upcoming/release-notes/7.0/";
    description = "MongoDB is a general purpose, document-based, distributed database.";
    homepage = "https://www.mongodb.com/";
    license = with lib.licenses; [ sspl ];
    longDescription = ''
      MongoDB CE (Community Edition) is a general purpose, document-based, distributed database.
      It is designed to be flexible and easy to use, with the ability to store data of any structure.
      This pre-compiled binary distribution package provides the MongoDB daemon (mongod) and the MongoDB Shard utility
      (mongos).
    '';
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.attrNames (srcs version);
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
