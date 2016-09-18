{stdenv, curl}:

stdenv.mkDerivation {
  name = "mesos-maven-deps";
  builder = ./fetch-mesos-deps.sh;

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "12c6z5yvp60v57f6nijifp14i56bb5614hac1qg528s9liaf8vml";

  buildInputs = [ curl ];

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
}
