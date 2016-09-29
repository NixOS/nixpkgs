{stdenv, curl}:

stdenv.mkDerivation {
  name = "mesos-maven-deps";
  builder = ./fetch-mesos-deps.sh;

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "066ikswavq3l37x1s3pfdncyj77pvpa0kj14ax5dqb9njmsg0s11";

  buildInputs = [ curl ];

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
}
