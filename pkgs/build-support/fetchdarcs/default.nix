{stdenv, darcs, nix}: {url, tag ? null, md5}:

stdenv.mkDerivation {
  name = "fetchdarcs";
  builder = ./builder.sh;
  buildInputs = [darcs nix];

  # Nix <= 0.7 compatibility.
  id = md5;

  outputHashAlgo = "md5";
  outputHashMode = "recursive";
  outputHash = md5;
  
  inherit url tag;
}
