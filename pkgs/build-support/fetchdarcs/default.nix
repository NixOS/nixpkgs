{stdenv, darcs, nix}: {url, tag ? null, context ? null, md5 ? "", sha256 ? ""}:

stdenv.mkDerivation {
  name = "fetchdarcs";
  builder = ./builder.sh;
  buildInputs = [darcs];

  outputHashAlgo = if sha256 == "" then "md5" else "sha256";
  outputHashMode = "recursive";
  outputHash = if sha256 == "" then md5 else sha256;
  
  inherit url tag context;
}
