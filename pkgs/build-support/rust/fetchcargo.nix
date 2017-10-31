{ stdenv, cacert, git, rust, cargoVendor }:
{ name ? "cargo-deps", src, srcs, sourceRoot, sha256, cargoUpdateHook ? "" }:
stdenv.mkDerivation {
  name = "${name}-vendor";
  buildInputs = [ cacert cargoVendor git rust.cargo ];
  inherit src srcs sourceRoot;

  phases = "unpackPhase installPhase";

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

    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
    export CARGO_HOME=$(mktemp -d cargo-home.XXX)

    cargo vendor

    cp -ar vendor $out
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
  preferLocalBuild = true;
}
