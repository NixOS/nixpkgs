{ fetchurl, stdenv, cacert, git, rust }:
{ name ? "cargo-deps", src, srcs, sourceRoot, sha256, cargoUpdateHook ? "" }:

let
  cargoLocalRegistry = import ./cargo-local-registry.nix {
    inherit fetchurl stdenv;
  };

in stdenv.mkDerivation {
  name = "${name}-fetch";
  buildInputs = [ cacert cargoLocalRegistry git rust.cargo ];
  inherit src srcs sourceRoot;

  phases = "unpackPhase installPhase";

  installPhase = ''
    if [[ ! -f Cargo.lock ]]; then
        echo
        echo "ERROR: The Cargo.lock file doesn't exist"
        echo
        echo "Cargo.lock is needed to make sure that depsSha256 doesn't change"
        echo "when the registry is updated."
        echo

        exit 1
    fi

    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
    export CARGO_HOME="$(mktemp -d cargo-home.XXX)"

    cargo local-registry --sync Cargo.lock --git "$out"

    # cargo-local-registry isn't reproducible.
    # https://github.com/alexcrichton/cargo-local-registry/issues/8
    for entry in "$out/index"/*/*/*; do
      sort "$entry" >sorted
      mv sorted "$entry"
    done
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
  preferLocalBuild = true;
}
