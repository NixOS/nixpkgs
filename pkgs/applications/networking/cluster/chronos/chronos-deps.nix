{stdenv, curl}:

stdenv.mkDerivation {
  name = "chronos-maven-deps";
  builder = ./fetch-chronos-deps.sh;

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0mm2sb1p5zz6b0z2s4zhdlix6fafydsxmqjy8zbkwzw4f6lazzyl";

  nativeBuildInputs = [ curl ];

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
}
