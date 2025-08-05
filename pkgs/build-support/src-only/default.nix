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
  argsToOverride = args: {
    name = "${args.name or "${args.pname}-${args.version}"}-source";

    outputs = [ "out" ];

    phases = [
      "unpackPhase"
      "patchPhase"
      "installPhase"
    ];
    separateDebugInfo = false;

    dontUnpack = lib.warnIf (args.dontUnpack or false
    ) "srcOnly: derivation has dontUnpack set, overriding" false;

    dontInstall = false;
    installPhase = "cp -pr --reflink=auto -- . $out";
  };
in

# If we are passed a derivation (based on stdenv*), we can use overrideAttrs to
# update the arguments to mkDerivation. This gives us the proper awareness of
# what arguments were effectively passed *to* mkDerivation as opposed to
# builtins.derivation (by mkDerivation). For example, stdenv.mkDerivation
# accepts an `env` attribute set which is postprocessed before being passed to
# builtins.derivation. This can lead to evaluation failures, if we assume
# that drvAttrs is equivalent to the arguments passed to mkDerivation.
# See https://github.com/NixOS/nixpkgs/issues/269539.
if lib.isDerivation attrs && attrs ? overrideAttrs then
  attrs.overrideAttrs (_finalAttrs: prevAttrs: argsToOverride prevAttrs)
else
  let
    # If we don't have overrideAttrs, it is extremely unlikely that we are seeing
    # a derivation constructed by stdenv.mkDerivation. Since srcOnly assumes
    # that we are using stdenv's setup.sh, it therefore doesn't make sense to
    # have derivation specific logic in this branch.
    # TODO(@sternenseemann): remove drvAttrs special casing in NixOS 26.05
    args =
      lib.warnIf (lib.isDerivation attrs)
        "srcOnly: derivations not created by a variant of stdenv.mkDerivation are not supported. Code relying on behaviour of srcOnly with non-stdenv derivations may break in the future."
        attrs.drvAttrs or attrs;
    stdenv = args.stdenv or (lib.warn "srcOnly: stdenv not provided, using stdenvNoCC" stdenvNoCC);
    drv = stdenv.mkDerivation (args // argsToOverride args);
  in
  drv
