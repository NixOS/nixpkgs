{stdenv, subversion, nix}: {url, rev ? "HEAD", md5}:

stdenv.mkDerivation {
  name = "svn-export";
  builder = ./builder.sh;
  buildInputs = [subversion nix];

  # Nix <= 0.7 compatibility.
  id = md5;

  outputHashAlgo = "md5";
  outputHashMode = "recursive";
  outputHash = md5;
  
  inherit url rev;
}
