{ stdenvNoCC, bazaar }:
{ url, rev, sha256 }:

stdenvNoCC.mkDerivation {
  name = "bzr-export";

  builder = ./builder.sh;
  nativeBuildInputs = [ bazaar ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;
  
  inherit url rev;
}
