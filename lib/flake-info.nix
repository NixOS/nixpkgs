# This function produces a lib overlay to be used by the nixpkgs
# & nixpkgs/lib flakes to provide meaningful values for
# `lib.trivial.version` et al..
#
# Internal and subject to change, don't use this anywhere else!
# Instead, consider using a public interface, such as this flake here
# in this directory, `lib/`, or use the nixpkgs flake, which applies
# this logic for you in its `lib` output attribute.

self: # from the flake

finalLib: prevLib: # lib overlay

{
  trivial = prevLib.trivial // {
    versionSuffix =
      ".${finalLib.substring 0 8 (self.lastModifiedDate or "19700101")}.${self.shortRev or "dirty"}";
    revisionWithDefault = default: self.rev or default;

    # This overrides the nixpkgsStorePathString logic in lib/trivial.nix for
    # the special case of flakes, where we are in pure eval mode and thus
    # would not be able to use builtins.storePath to establish a dependency on
    # this nixpkgs' sources (https://github.com/NixOS/nix/issues/5868).
    #
    # However, in this particular case, due to being used from a flake, we *do*
    # have a string with context for our own sources in the store in the
    # `outPath` of the `self` flake input, which we obtain by calling toString
    # on it.
    nixpkgsStorePathString = toString self;
  };
}
