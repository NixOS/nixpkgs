{stdenvNoCC, darcs, cacert, lib}:

lib.makeOverridable (
{ url
, rev ? null
, context ? null
, sha256 ? ""
, name ? "fetchdarcs"
}:

stdenvNoCC.mkDerivation {
  builder = ./builder.sh;
  nativeBuildInputs = [cacert darcs];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  inherit url rev context name;
}
)
