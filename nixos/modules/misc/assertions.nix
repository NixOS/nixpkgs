{
  # Not `lib.genericModules.assertions`: the `lib` module argument may come from a
  # different Nixpkgs version than this file.
  imports = [ ../../../lib/modules/generic/assertions.nix ];
}
