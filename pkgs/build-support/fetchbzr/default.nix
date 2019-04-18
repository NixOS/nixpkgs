{ stdenvNoCC, bazaar }:
{ url, rev, sha256, name ? "bzr-export" }:

stdenvNoCC.mkDerivation {
  builder = ./builder.sh;
  nativeBuildInputs = [ bazaar ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;
  
  inherit url rev name;
}
