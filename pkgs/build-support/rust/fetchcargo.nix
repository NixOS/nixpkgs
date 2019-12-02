{ stdenv, cacert, git, cargo, python3 }:
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
    # check that ./fetchcargo-default-config.toml is a fix point
    reference=${./fetchcargo-default-config.toml}
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
, sourceRoot
, sha256
, cargoUpdateHook ? ""
, # whenever to also include the Cargo.lock in the output
  copyLockfile ? false
, ...
} @ args:
stdenv.mkDerivation ({
  name = "${name}-vendor";
  nativeBuildInputs = [ cacert git cargo-vendor-normalise cargo ];

  phases = "unpackPhase patchPhase installPhase";

  installPhase = ''
    if [[ ! -f Cargo.lock ]]; then
        echo
        echo "ERROR: The Cargo.lock file doesn't exist"
        echo
        echo "Cargo.lock is needed to make sure that cargoSha256 doesn't change"
        echo "when the registry is updated."
        echo

        exit 1
    fi

    # Keep the original around for copyLockfile
    cp Cargo.lock Cargo.lock.orig

    export CARGO_HOME=$(mktemp -d cargo-home.XXX)
    CARGO_CONFIG=$(mktemp cargo-config.XXXX)

    ${cargoUpdateHook}

    mkdir -p $out
    cargo vendor $out | cargo-vendor-normalise > $CARGO_CONFIG
    # fetchcargo used to never keep the config output by cargo vendor
    # and instead hardcode the config in ./fetchcargo-default-config.toml.
    # This broke on packages needing git dependencies, so now we keep the config.
    # But not to break old cargoSha256, if the previous behavior was enough,
    # we don't store the config.
    if ! cmp $CARGO_CONFIG ${./fetchcargo-default-config.toml} > /dev/null; then
      install -D $CARGO_CONFIG $out/.cargo/config;
    fi;

  '' + stdenv.lib.optionalString copyLockfile ''
    # add the Cargo.lock to allow hash invalidation
    cp Cargo.lock.orig $out/Cargo.lock
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
  preferLocalBuild = true;
} // (builtins.removeAttrs args [
  "name" "sha256" "cargoUpdateHook" "copyLockfile"
]))
