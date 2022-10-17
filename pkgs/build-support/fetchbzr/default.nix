{ stdenvNoCC, breezy }:
{ url, rev, sha256 }:

stdenvNoCC.mkDerivation {
  name = "bzr-export";

  builder = ./builder.sh;
  nativeBuildInputs = [ breezy ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  inherit url rev;
}
