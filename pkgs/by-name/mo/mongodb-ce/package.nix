{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  curl,
  openssl,
  versionCheckHook,
  writeShellApplication,
  common-updater-scripts,
  gitMinimal,
  jq,
  nix-update,
  pup,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mongodb-ce";
  version = "8.0.14";

  src =
    finalAttrs.passthru.sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported platform for mongodb-ce: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  dontStrip = true;

  buildInputs = [
    curl.dev
    openssl.dev
    (lib.getLib stdenv.cc.cc)
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 755 bin/mongod -t $out/bin
    install -Dm 755 bin/mongos -t $out/bin

    runHook postInstall
  '';

  # Only enable the version install check on darwin.
  # On Linux, this would fail as mongod relies on tcmalloc, which
  # requires access to `/sys/devices/system/cpu/possible`.
  # See https://github.com/NixOS/nixpkgs/issues/377016
  doInstallCheck = stdenv.hostPlatform.isDarwin;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/mongod";
  versionCheckProgramArg = "--version";

  passthru = {
    sources = {
      "x86_64-linux" = fetchurl {
        url = "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2404-${finalAttrs.version}.tgz";
        hash = "sha256-nmqDMu8O3bUveGnUNjISs8o3mVX9cNgIQNG3+m9ctUs=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://fastdl.mongodb.org/linux/mongodb-linux-aarch64-ubuntu2404-${finalAttrs.version}.tgz";
        hash = "sha256-Os4aK+r5SBzgtkRz81FcRywTgs5gKzGTOZfb/Z8H2ns=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://fastdl.mongodb.org/osx/mongodb-macos-x86_64-${finalAttrs.version}.tgz";
        hash = "sha256-x4pFuAFgp+7n/knezCwjasXh4c338kXdjA7L259bRKw=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://fastdl.mongodb.org/osx/mongodb-macos-arm64-${finalAttrs.version}.tgz";
        hash = "sha256-apcmzl8HIWaP8I3OjTX2Vzcwx5ruztqPFDzoLf8Fn14=";
      };
    };
    updateScript =
      let
        script = writeShellApplication {
          name = "${finalAttrs.pname}-updateScript";

          runtimeInputs = [
            common-updater-scripts
            curl
            gitMinimal
            jq
            nix-update
            pup
          ];

          text = ''
            # Get latest version string from Github
            NEW_VERSION=$(curl -s "https://api.github.com/repos/mongodb/mongo/tags?per_page=1000" | jq -r 'first(.[] | .name | select(startswith("r8.0")) | select(contains("rc") | not) | .[1:])')

            # Check if the new version is available for download, if not, exit
            curl -s https://www.mongodb.com/try/download/community-edition/releases | pup 'h3:not([id]) text{}' | grep "$NEW_VERSION"

            if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
                echo "The new version same as the old version."
                exit 0
            fi

            for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
              update-source-version "mongodb-ce" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
            done
          '';
        };
      in
      {
        command = lib.getExe script;
      };

    tests = {
      inherit (nixosTests) mongodb-ce;
    };
  };

  meta = {
    changelog = "https://www.mongodb.com/docs/upcoming/release-notes/8.0/";
    description = "MongoDB is a general purpose, document-based, distributed database";
    homepage = "https://www.mongodb.com/";
    license = with lib.licenses; [ sspl ];
    longDescription = ''
      MongoDB CE (Community Edition) is a general purpose, document-based, distributed database.
      It is designed to be flexible and easy to use, with the ability to store data of any structure.
      This pre-compiled binary distribution package provides the MongoDB daemon (mongod) and the MongoDB Shard utility
      (mongos).
    '';
    maintainers = with lib.maintainers; [ ];
    platforms = lib.attrNames finalAttrs.passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
