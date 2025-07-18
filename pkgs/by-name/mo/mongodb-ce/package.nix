{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  curl,
  openssl,
  versionCheckHook,
  writeShellApplication,
  jq,
  nix-update,
  gitMinimal,
  pup,
  nixosTests,
}:

let
  version = "8.0.11";

  srcs = version: {
    "x86_64-linux" = {
      url = "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2204-${version}.tgz";
      hash = "sha256-XErxsovZyMR1UmwClxn5Bm08hoYHArCtn8TSv/8eDYo=";
    };
    "aarch64-linux" = {
      url = "https://fastdl.mongodb.org/linux/mongodb-linux-aarch64-ubuntu2204-${version}.tgz";
      hash = "sha256-p1eBobdnJ/uPZHScWFs3AOB7/BJn/MZQ8+VpOHonY2A=";
    };
    "x86_64-darwin" = {
      url = "https://fastdl.mongodb.org/osx/mongodb-macos-x86_64-${version}.tgz";
      hash = "sha256-RLq+aFJixSt3EginpgIHWnR4CGk0KX5cmC3QrbW3jJ8=";
    };
    "aarch64-darwin" = {
      url = "https://fastdl.mongodb.org/osx/mongodb-macos-arm64-${version}.tgz";
      hash = "sha256-kNzByPEXi5T3+vr6t/EJuKIDEfGybrsbBqJ8vaEV5tY=";
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
    (lib.getLib stdenv.cc.cc)
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 755 bin/mongod -t $out/bin
    install -Dm 755 bin/mongos -t $out/bin
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/mongod";
  versionCheckProgramArg = "--version";
  # Only enable the version install check on darwin.
  # On Linux, this would fail as mongod relies on tcmalloc, which
  # requires access to `/sys/devices/system/cpu/possible`.
  # See https://github.com/NixOS/nixpkgs/issues/377016
  doInstallCheck = stdenv.hostPlatform.isDarwin;

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
              NEW_VERSION=$(curl -s "https://api.github.com/repos/mongodb/mongo/tags?per_page=1000" | jq -r 'first(.[] | .name | select(startswith("r8.0")) | select(contains("rc") | not) | .[1:])')

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

    tests = {
      inherit (nixosTests) mongodb-ce;
    };
  };

  meta = {
    changelog = "https://www.mongodb.com/docs/upcoming/release-notes/8.0/";
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
