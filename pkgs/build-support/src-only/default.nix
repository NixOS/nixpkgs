{ lib, stdenvNoCC }:

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
  stdenv = args.stdenv or (lib.warn "srcOnly: stdenv not provided, using stdenvNoCC" stdenvNoCC);
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
lib.warnIf (args.dontUnpack or false) "srcOnly: derivation has dontUnpack set, overriding" drv
