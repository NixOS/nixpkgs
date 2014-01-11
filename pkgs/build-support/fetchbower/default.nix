{ stdenv, fetch-bower, git }: name: version: target: outputHash: stdenv.mkDerivation {
  name = "${name}-${version}";
  realBuilder = "${fetch-bower}/bin/fetch-bower";
  args = [ name version target ];
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  inherit outputHash;
  PATH = "${git}/bin";
}
