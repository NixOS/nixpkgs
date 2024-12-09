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
  };
}
