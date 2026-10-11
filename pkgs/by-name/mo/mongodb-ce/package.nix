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
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mongodb-ce";
  version = "8.3.11";
  __structuredAttrs = true;
  strictDeps = true;

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

  # Apple's LibreSSL tries to read this while running `mongod --version`
  sandboxProfile = lib.optionalString stdenv.hostPlatform.isDarwin ''
    (allow file-read* (literal "/private/etc/ssl/openssl.cnf"))
  '';

  passthru = {
    sources = {
      "x86_64-linux" = fetchurl {
        url = "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2404-${finalAttrs.version}.tgz";
        hash = "sha256-qKpPddwPKmarQhUpuxRSSFIixsmJCbBHqY2QmBw06r4=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://fastdl.mongodb.org/linux/mongodb-linux-aarch64-ubuntu2404-${finalAttrs.version}.tgz";
        hash = "sha256-UlQL+x3nrUFVJMalEX1DT82E8k8j49tW5xl36f7Sjy4=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://fastdl.mongodb.org/osx/mongodb-macos-arm64-${finalAttrs.version}.tgz";
        hash = "sha256-tYbDlyiA/N6pBpCm0iwizSYLCXLecXynEMC8d8ZLA54=";
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
          ];

          text = ''
            # Pick the newest production (non-RC) release within the current major version from
            # MongoDB's official release feed. Major upgrades are left as a deliberate manual change.
            # A version only shows up in the feed once its binaries are published, so no separate
            # download-availability check is needed.
            NEW_VERSION=$(curl -s https://downloads.mongodb.org/current.json \
              | jq -r --arg major "${lib.versions.major finalAttrs.version}" \
                '[.versions[] | select(.production_release and (.release_candidate | not)) | .version | select(startswith($major + "."))] | sort_by(split(".") | map(tonumber)) | last')

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
    changelog = "https://www.mongodb.com/docs/upcoming/release-notes/${lib.versions.majorMinor finalAttrs.version}/";
    description = "MongoDB is a general purpose, document-based, distributed database";
    homepage = "https://www.mongodb.com/";
    license = lib.licenses.sspl;
    longDescription = ''
      MongoDB CE (Community Edition) is a general purpose, document-based, distributed database.
      It is designed to be flexible and easy to use, with the ability to store data of any structure.
      This pre-compiled binary distribution package provides the MongoDB daemon (mongod) and the MongoDB Shard utility
      (mongos).
    '';
    maintainers = with lib.maintainers; [
      wrbbz
    ];
    platforms = lib.attrNames finalAttrs.passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
