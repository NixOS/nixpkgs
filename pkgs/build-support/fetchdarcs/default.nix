{stdenv, darcs, nix}: {url, tag ? null, md5, partial ? true}:

stdenv.mkDerivation {
  name = "fetchdarcs";
  builder = ./builder.sh;
  buildInputs = [darcs nix];
  partial = if partial then "--partial" else "";

  # Nix <= 0.7 compatibility.
  id = md5;

  outputHashAlgo = "md5";
  outputHashMode = "recursive";
  outputHash = md5;
  
  inherit url tag;
}
