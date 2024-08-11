{ stdenv }:
# srcOnly is a utility builder that only fetches and unpacks the given `src`,
# and optionally patching with `patches` or adding build inputs.
#
# It can be invoked directly, or be used to wrap an existing derivation. Eg:
#
# > srcOnly pkgs.hello
#
{
  noSuffix ? false,
  ...
}@attrs:
let
  args = if attrs ? drvAttrs then attrs.drvAttrs else attrs;
  name = if args ? name then args.name else "${args.pname}-${args.version}";
in
stdenv.mkDerivation (
  args
  // {
    name = if noSuffix then name else "${name}-source";
    installPhase = "cp -pr --reflink=auto -- . $out";
    outputs = [ "out" ];
    separateDebugInfo = false;
    dontUnpack = false;
    dontInstall = false;
    phases = [
      "unpackPhase"
      "patchPhase"
      "installPhase"
    ];
  }
)
