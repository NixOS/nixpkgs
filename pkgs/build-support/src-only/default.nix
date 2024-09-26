{ lib, stdenv }:

# srcOnly is a utility builder that only fetches and unpacks the given `src`,
# and optionally patching with `patches` or adding build inputs.
#
# It can be invoked directly, or be used to wrap an existing derivation. Eg:
#
# > srcOnly pkgs.hello
#

attrs:
let
  args = attrs.drvAttrs or attrs;
  name = args.name or "${args.pname}-${args.version}";
  drv = stdenv.mkDerivation (
    args
    // {
      name = "${name}-source";

      phases = [
        "unpackPhase"
        "patchPhase"
        "installPhase"
      ];
      separateDebugInfo = false;

      dontUnpack = false;

      dontInstall = false;
      installPhase = "cp -pr --reflink=auto -- . $out";
    }
  );
in
drv
