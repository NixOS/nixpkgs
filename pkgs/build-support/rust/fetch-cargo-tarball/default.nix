{ lib, stdenv, cacert, git, cargo, python3 }:
let cargo-vendor-normalise = stdenv.mkDerivation {
  name = "cargo-vendor-normalise";
  src = ./cargo-vendor-normalise.py;
  nativeBuildInputs = [ python3.pkgs.wrapPython ];
  dontUnpack = true;
  installPhase = "install -D $src $out/bin/cargo-vendor-normalise";
  pythonPath = [ python3.pkgs.toml ];
  postFixup = "wrapPythonPrograms";
  doInstallCheck = true;
  installCheckPhase = ''
    # check that ../fetchcargo-default-config.toml is a fix point
    reference=${../fetchcargo-default-config.toml}
    < $reference $out/bin/cargo-vendor-normalise > test;
    cmp test $reference
  '';
  preferLocalBuild = true;
};
in
{ name ? "cargo-deps"
, src ? null
, srcs ? []
, patches ? []
, sourceRoot ? ""
, cargoUpdateHook ? ""
, nativeBuildInputs ? []
, ...
} @ args:

let hash_ =
  if args ? hash then { outputHashAlgo = null; outputHash = args.hash; }
  else if args ? sha256 then { outputHashAlgo = "sha256"; outputHash = args.sha256; }
  else throw "fetchCargoTarball requires a hash for ${name}";
in stdenv.mkDerivation ({
  name = "${name}-vendor.tar.gz";
  nativeBuildInputs = [ cacert git cargo-vendor-normalise cargo ] ++ nativeBuildInputs;

  buildPhase = ''
    runHook preBuild

    # Ensure deterministic Cargo vendor builds
    export SOURCE_DATE_EPOCH=1

    if [[ ! -f Cargo.lock ]]; then
        echo
        echo "ERROR: The Cargo.lock file doesn't exist"
        echo
        echo "Cargo.lock is needed to make sure that cargoHash/cargoSha256 doesn't change"
        echo "when the registry is updated."
        echo

        exit 1
    fi

    # Keep the original around for copyLockfile
    cp Cargo.lock Cargo.lock.orig

    export CARGO_HOME=$(mktemp -d cargo-home.XXX)
    CARGO_CONFIG=$(mktemp cargo-config.XXXX)

    if [[ -n "$NIX_CRATES_INDEX" ]]; then
    cat >$CARGO_HOME/config.toml <<EOF
    [source.crates-io]
    replace-with = 'mirror'
    [source.mirror]
    registry = "$NIX_CRATES_INDEX"
    EOF
    fi

    ${cargoUpdateHook}

    cargo vendor $name --respect-source-config | cargo-vendor-normalise > $CARGO_CONFIG

    # Add the Cargo.lock to allow hash invalidation
    cp Cargo.lock.orig $name/Cargo.lock

    # Packages with git dependencies generate non-default cargo configs, so
    # always install it rather than trying to write a standard default template.
    install -D $CARGO_CONFIG $name/.cargo/config;

    runHook postBuild
  '';

  # Build a reproducible tar, per instructions at https://reproducible-builds.org/docs/archives/
  installPhase = ''
    tar --owner=0 --group=0 --numeric-owner --format=gnu \
        --sort=name --mtime="@$SOURCE_DATE_EPOCH" \
        -czf $out $name
  '';

  inherit (hash_) outputHashAlgo outputHash;

  impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [ "NIX_CRATES_INDEX" ];
} // (builtins.removeAttrs args [
  "name" "sha256" "cargoUpdateHook" "nativeBuildInputs"
]))
