{stdenv, mercurial, nix}: {url, tag ? null, md5}:

# TODO: statically check if mercurial as the https support if the url starts woth https.
stdenv.mkDerivation {
  name = "fetchhg";
  builder = ./builder.sh;
  buildInputs = [mercurial nix];

  # Nix <= 0.7 compatibility.
  id = md5;

  outputHashAlgo = "md5";
  outputHashMode = "recursive";
  outputHash = md5;
  
  inherit url tag;
}
