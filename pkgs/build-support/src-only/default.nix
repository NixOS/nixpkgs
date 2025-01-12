{ lib, stdenvNoCC }:

/**
  A utility builder to get the source code of the input derivation, with any patches applied.

  # Examples

  ```nix
  srcOnly pkgs.hello
  => «derivation /nix/store/gyfk2jg9079ga5g5gfms5i4h0k9jhf0f-hello-2.12.1-source.drv»

  srcOnly {
    inherit (pkgs.hello) name version src stdenv;
  }
  => «derivation /nix/store/vf9hdhz38z7rfhzhrk0vi70h755fnsw7-hello-2.12.1-source.drv»
  ```

  # Type

  ```
  srcOnly :: (Derivation | AttrSet) -> Derivation
  ```

  # Input

  `attrs`

  : One of the following:

    - A derivation with (at minimum) an unpackPhase and a patchPhase.
    - A set of attributes that would be passed to a `stdenv.mkDerivation` or `stdenvNoCC.mkDerivation` call.

  # Output

  A derivation that runs a derivation's `unpackPhase` and `patchPhase`, and then copies the result to the output path.
*/

attrs:
let
  args = attrs.drvAttrs or attrs;
  name = args.name or "${args.pname}-${args.version}";
  stdenv = args.stdenv or (lib.warn "srcOnly: stdenv not provided, using stdenvNoCC" stdenvNoCC);
  drv = stdenv.mkDerivation (
    args
    // {
      name = "${name}-source";

      outputs = [ "out" ];

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
