{stdenv, darcs, nix, cacert}:

{url, rev ? null, context ? null, md5 ? "", sha256 ? ""}:

if md5 != "" then
  throw "fetchdarcs does not support md5 anymore, please use sha256"
else
stdenv.mkDerivation {
  name = "fetchdarcs";
  builder = ./builder.sh;
  buildInputs = [cacert darcs];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  inherit url rev context;
}
