{stdenv, curl}:

stdenv.mkDerivation {
  name = "mesos-maven-deps";
  builder = ./fetch-mesos-deps.sh;

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "12c6z5yvp60v57f6nijifp14i56bb5614hac1qg528s9liaf8vml";

  buildInputs = [ curl ];

  # We borrow these environment variables from the caller to allow
  # easy proxy configuration.  This is impure, but a fixed-output
  # derivation like fetchurl is allowed to do so since its result is
  # by definition pure.
  impureEnvVars = ["http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"];
}
