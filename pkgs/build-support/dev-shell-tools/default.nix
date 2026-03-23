{
  lib,
  writeText,
}:
let
  inherit (builtins) typeOf;
in
rec {
  # Docs: doc/build-helpers/dev-shell-tools.chapter.md
  # Tests: ./tests/default.nix
  # This function closely mirrors what this Nix code does:
  # https://github.com/NixOS/nix/blob/2.8.0/src/libexpr/primops.cc#L1102
  # https://github.com/NixOS/nix/blob/2.8.0/src/libexpr/eval.cc#L1981-L2036
  valueToString =
    value:
    # We can't just use `toString` on all derivation attributes because that
    # would not put path literals in the closure. So we explicitly copy
    # those into the store here
    if typeOf value == "path" then
      "${value}"
    else if typeOf value == "list" then
      toString (map valueToString value)
    else
      toString value;

  # Docs: doc/build-helpers/dev-shell-tools.chapter.md
  # Tests: ./tests/default.nix
  # https://github.com/NixOS/nix/blob/2.8.0/src/libstore/build/local-derivation-goal.cc#L992-L1004
  unstructuredDerivationInputEnv =
    { drvAttrs }:
    # FIXME: this should be `normalAttrs // passAsFileAttrs`
    lib.mapAttrs'
      (
        name: value:
        let
          str = valueToString value;
        in
        if lib.elem name (drvAttrs.passAsFile or [ ]) then
          lib.nameValuePair "${name}Path" "${writeText "shell-passAsFile-${name}" str}"
        else
          lib.nameValuePair name str
      )
      (
        removeAttrs drvAttrs [
          # TODO: there may be more of these
          "args"
        ]
      );

  # Docs: doc/build-helpers/dev-shell-tools.chapter.md
  # Tests: ./tests/default.nix
  derivationOutputEnv =
    { outputList, outputMap }:
    # A mapping from output name to the nix store path where they should end up
    # https://github.com/NixOS/nix/blob/2.8.0/src/libexpr/primops.cc#L1253
    lib.genAttrs outputList (output: builtins.unsafeDiscardStringContext outputMap.${output}.outPath);

}
