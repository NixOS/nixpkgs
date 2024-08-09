{
  runtimesPath,
  rustPlatform,
  makeWrapper,
  pkg-config,
  protobuf,
  openssl,
  version,
  src,
  lib,
  ...
}: let
  cargoLockFile = ./tsparser-Cargo.lock;
in
  rustPlatform.buildRustPackage {
    pname = "tsparser-encore";

    inherit src version;

    nativeBuildInputs = [
      makeWrapper
      pkg-config
      openssl
    ];

    buildInputs = [
      protobuf
    ];

    buildAndTestSubdir = "tsparser";

    doCheck = false;

    patchPhase = ''
      runHook prePatch

      # the build complains about the diff between both cargo.lock files and
      # is necessary to have a cargo.lock since it contains git deps
      rm -rf tsparser/Cargo.lock
      cp ${cargoLockFile} Cargo.lock

      # to avoid to compile "broken" members
      rm -rf runtimes
      substituteInPlace Cargo.toml \
        --replace 'members = ["runtimes/core", "runtimes/js", "tsparser"]' 'members = ["tsparser"]' \

      substituteInPlace tsparser/src/bin/tsparser-encore.rs \
        --replace 'Some(err) => err.0.as_str(),' 'Some(err) => err.0.clone(),'

      substituteInPlace tsparser/src/bin/tsparser-encore.rs \
        --replace 'None => &format!("{:?}", err),' 'None => format!("{:?}", err),'

      runHook postPatch
    '';

    preBuild = ''
      export PROTOC="${lib.getExe protobuf}"
    '';

    postInstall = ''
      wrapProgram $out/bin/tsparser-encore \
        --set ENCORE_JS_RUNTIME_PATH ${runtimesPath}/js
    '';

    cargoLock = {
      lockFile = cargoLockFile;
      outputHashes = {
        "ast_node-0.9.5" = "sha256-EQGbqlwINoCgWEblUyuRcrxwg29K4tYpexhmGHPY15Q=";
        "postgres-protocol-0.6.6" = "sha256-1acUGWeNOqIteie78++U+g7ghBTsOLUzSRZ2AQlDbXA=";
      };
    };
  }
