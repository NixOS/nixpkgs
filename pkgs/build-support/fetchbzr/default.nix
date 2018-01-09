{ stdenv, bazaar }: 
{ url, rev, sha256 }:

stdenv.mkDerivation {
  name = "bzr-export";

  builder = ./builder.sh;
  nativeBuildInputs = [ bazaar ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;
  
  inherit url rev;
}
