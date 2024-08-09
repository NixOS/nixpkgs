# This function produces a lib overlay to be used by the nixpkgs
# & nixpkgs/lib to provide meaningful values for
# `lib.trivial.version` et al..
#
# Internal and subject to change, don't use this anywhere else!

# from caller
{
  # finalLib -> string
  # or string
  versionSuffix,
  # default -> string
  # or string
  revision ? null,
}:

finalLib: prevLib: # lib overlay

{
  trivial = prevLib.trivial // {
    versionSuffix =
      if finalLib.isFunction versionSuffix then versionSuffix finalLib
      else versionSuffix;
    revisionWithDefault =
      if finalLib.isFunction revision then revision
      else if finalLib.isString revision then _: revision
      else default: default;
  };
}
