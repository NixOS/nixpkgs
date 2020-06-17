{ stdenv }@orig:
# srcOnly is a utility builder that only fetches and unpacks the given `src`,
# maybe pathings it in the process with the optional `patches` and
# `buildInputs` attributes.
#
# It can be invoked directly, or be used to wrap an existing derivation. Eg:
#
# > srcOnly pkgs.hello
#
{ name
, src
, stdenv ? orig.stdenv
, patches ? []
, # deprecated, use the nativeBuildInputs
  buildInputs ? []
, # used to pass extra unpackers
  nativeBuildInputs ? []
, # needed when passing an existing derivation
  ...
}:
stdenv.mkDerivation {
  inherit
    buildInputs
    name
    nativeBuildInputs
    patches
    src
    ;
  installPhase = "cp -r . $out";
  phases = ["unpackPhase" "patchPhase" "installPhase"];
}
