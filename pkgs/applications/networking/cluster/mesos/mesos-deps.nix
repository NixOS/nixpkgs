{stdenv, curl}:

stdenv.mkDerivation {
  name = "mesos-maven-deps";
  builder = ./fetch-mesos-deps.sh;

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "10h0qs7svw0cqjkyxs8z6s3qraa8ga920zfrr59rdlanbwg4klly";

  buildInputs = [ curl ];

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
}
