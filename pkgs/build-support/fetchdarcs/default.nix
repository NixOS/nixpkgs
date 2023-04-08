{stdenvNoCC, darcs, cacert}:

{ url
, rev ? null
, context ? null
, md5 ? ""
, sha256 ? ""
, name ? "fetchdarcs"
}:

if md5 != "" then
  throw "fetchdarcs does not support md5 anymore, please use sha256"
else
stdenvNoCC.mkDerivation {
  builder = ./builder.sh;
  nativeBuildInputs = [cacert darcs];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  inherit url rev context name;
}
