# lib overlay to be used by the nixpkgs & nixpkgs/lib flakes
# to provide meaningful values for `lib.trivial.version` et al..
#
# Internal and subject to change, don't use this anywhere else!

self: # from the flake

finalLib: prevLib: # lib overlay

{
  trivial = prevLib.trivial // {
    versionSuffix =
      ".${finalLib.substring 0 8 (self.lastModifiedDate or self.lastModified or "19700101")}.${self.shortRev or "dirty"}";
    version = finalLib.trivial.release + finalLib.trivial.versionSuffix;
    revisionWithDefault = default: self.rev or default;
  };
}
