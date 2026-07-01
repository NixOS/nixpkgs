{
  stdenvNoCC,
  darcs,
  cacert,
  lib,
}:

lib.makeOverridable (
  lib.fetchers.withNormalizedHash { } (
    {
      # Repository to fetch
      url,
      # Additional list of repositories specifying alternative download
      # location to be tried in order, if the prior repository failed to fetch.
      mirrors ? [ ],
      rev ? null,
      context ? null,
      outputHash ? lib.fakeHash,
      outputHashAlgo ? null,
      name ? "fetchdarcs",
    }:

    stdenvNoCC.mkDerivation {
      builder = ./builder.sh;
      nativeBuildInputs = [
        cacert
        darcs
      ];

      inherit outputHash outputHashAlgo;
      outputHashMode = "recursive";

      inherit
        rev
        context
        name
        ;

      repositories = [ url ] ++ mirrors;
    }
  )
)
