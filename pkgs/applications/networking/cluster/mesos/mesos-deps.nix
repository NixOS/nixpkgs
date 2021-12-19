{stdenv, curl}:

stdenv.mkDerivation {
  name = "mesos-maven-deps";
  builder = ./fetch-mesos-deps.sh;

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0c8iflv8s73d17nkkhmb4xb325m5qhqp6l7ch21kf7h5fj6l474h";

  nativeBuildInputs = [ curl ];

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
}
