{ lib }:
let
  inherit (builtins) typeOf;
in
rec {
  # This function closely mirrors what this Nix code does:
  # https://github.com/NixOS/nix/blob/2.8.0/src/libexpr/primops.cc#L1102
  # https://github.com/NixOS/nix/blob/2.8.0/src/libexpr/eval.cc#L1981-L2036
  valueToString = value:
    # We can't just use `toString` on all derivation attributes because that
    # would not put path literals in the closure. So we explicitly copy
    # those into the store here
    if typeOf value == "path" then "${value}"
    else if typeOf value == "list" then toString (map valueToString value)
    else toString value;
}
