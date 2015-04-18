{stdenv, curl}:

stdenv.mkDerivation {
  name = "chronos-maven-deps";
  builder = ./fetch-chronos-deps.sh;

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0mm2sb1p5zz6b0z2s4zhdlix6fafydsxmqjy8zbkwzw4f6lazzyl";

  buildInputs = [ curl ];

  # We borrow these environment variables from the caller to allow
  # easy proxy configuration.  This is impure, but a fixed-output
  # derivation like fetchurl is allowed to do so since its result is
  # by definition pure.
  impureEnvVars = ["http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"];
}
