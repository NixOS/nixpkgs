{ fetchurl, stdenv, callPackage, path, cacert, git, rust }:

{ name, depsSha256
, src ? null
, srcs ? null
, sourceRoot ? null
, logLevel ? ""
, buildInputs ? []
, cargoUpdateHook ? ""
, cargoDepsHook ? ""
, cargoBuildFlags ? []
, ... } @ args:

let
  lib = stdenv.lib;

  fetchDeps = import ./fetchcargo.nix {
    inherit fetchurl stdenv cacert git rust;
  };

  cargoDeps = fetchDeps {
    inherit name src srcs sourceRoot cargoUpdateHook;
    sha256 = depsSha256;
  };

in stdenv.mkDerivation (args // {
  inherit cargoDeps;

  patchRegistryDeps = ./patch-registry-deps;

  buildInputs = [ git rust.cargo rust.rustc ] ++ buildInputs;

  configurePhase = args.configurePhase or ''
    runHook preConfigure
    # noop
    runHook postConfigure
  '';

  postUnpack = ''
    eval "$cargoDepsHook"

    mkdir .cargo
    cat >.cargo/config <<-EOF
      [source.crates-io]
      registry = 'https://github.com/rust-lang/crates.io-index'
      replace-with = 'local-registry'

      [source.local-registry]
      local-registry = '$cargoDeps'
    EOF

    export CARGO_HOME="$(pwd)/deps"
    export RUST_LOG=${logLevel}
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt

    # Unpack crates. This is only needed for $patchRegistryDeps
    cargo fetch --frozen --verbose --manifest-path "$sourceRoot/Cargo.toml"
  '' + (args.postUnpack or "");

  prePatch = ''
    # Patch registry dependencies, using the scripts in $patchRegistryDeps
    (
        set -euo pipefail

        cd "$CARGO_HOME/registry/src/"*

        for script in $patchRegistryDeps/*; do
          # Run in a subshell so that directory changes and shell options don't
          # affect any following commands

          ( . $script)
        done
    )
  '' + (args.prePatch or "");

  buildPhase = with builtins; args.buildPhase or ''
    runHook preBuild
    echo "Running cargo build --release ${concatStringsSep " " cargoBuildFlags}"
    cargo build --release --frozen ${concatStringsSep " " cargoBuildFlags}
    runHook postBuild
  '';

  checkPhase = args.checkPhase or ''
    runHook preCheck
    echo "Running cargo test"
    cargo test
    runHook postCheck
  '';

  doCheck = args.doCheck or true;

  installPhase = args.installPhase or ''
    runHook preInstall
    mkdir -p $out/bin
    find target/release -maxdepth 1 -executable -exec cp "{}" $out/bin \;
    runHook postInstall
  '';
})
