{stdenv, cvs, nix}: {url, module, tag, md5}:

stdenv.mkDerivation {
  name = "cvs-export";
  builder = ./builder.sh;
  buildInputs = [cvs nix];

  # Nix <= 0.7 compatibility.
  id = md5;

  outputHashAlgo = "md5";
  outputHashMode = "recursive";
  outputHash = md5;
  
  inherit url module tag;
}
