{ stdenv, cacert, git, rust, cargo-vendor }:
let
  fetchcargo = import ./fetchcargo.nix {
    inherit stdenv cacert git rust cargo-vendor;
  };
in
{ name, cargoSha256 ? "unset"
, src ? null
, srcs ? null
, cargoPatches ? []
, patches ? []
, sourceRoot ? null
, logLevel ? ""
, buildInputs ? []
, cargoUpdateHook ? ""
, cargoDepsHook ? ""
, cargoBuildFlags ? []

, cargoVendorDir ? null
# This tells cargo-vendor to include a Cargo config file in the fixed-output
# derivation. This is desirable in every case, so please set it to true.
# Eventually this will default to true and even later this option and the old
# behaviour will be removed.
, useRealVendorConfig ? false
, ... } @ args:

assert cargoVendorDir == null -> cargoSha256 != "unset";
assert cargoVendorDir != null -> !useRealVendorConfig;

let
  cargoDeps = if cargoVendorDir == null
    then fetchcargo {
        inherit name src srcs sourceRoot cargoUpdateHook;
        patches = cargoPatches;
        sha256 = cargoSha256;
        writeVendorConfig = useRealVendorConfig;
      }
    else null;

  setupVendorDir = if cargoVendorDir == null
    then ''
      unpackFile "$cargoDeps"
      cargoDepsCopy=$(stripHash $(basename $cargoDeps))
      chmod -R +w "$cargoDepsCopy"
    ''
    else ''
      cargoDepsCopy="$sourceRoot/${cargoVendorDir}"
    '';

in stdenv.mkDerivation (args // {
  inherit cargoDeps;

  patchRegistryDeps = ./patch-registry-deps;

  buildInputs = [ cacert git rust.cargo rust.rustc ] ++ buildInputs;

  patches = cargoPatches ++ patches;

  configurePhase = args.configurePhase or ''
    runHook preConfigure
    # noop
    runHook postConfigure
  '';

  postUnpack = ''
    eval "$cargoDepsHook"

    ${setupVendorDir}

    mkdir .cargo
  '' + (if useRealVendorConfig then ''
      sed "s|directory = \".*\"|directory = \"$(pwd)/$cargoDepsCopy\"|g" \
        "$(pwd)/$cargoDepsCopy/.cargo/config" > .cargo/config
    '' else ''
      cat >.cargo/config <<-EOF
        [source.crates-io]
        registry = 'https://github.com/rust-lang/crates.io-index'
        replace-with = 'vendored-sources'

        [source.vendored-sources]
        directory = '$(pwd)/$cargoDepsCopy'
      EOF
    '') + ''

    unset cargoDepsCopy

    export RUST_LOG=${logLevel}
  '' + (args.postUnpack or "");

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
    find target/release -maxdepth 1 -executable -type f -exec cp "{}" $out/bin \;
    runHook postInstall
  '';

  passthru = { inherit cargoDeps; } // (args.passthru or {});
})
