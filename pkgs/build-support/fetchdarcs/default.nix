{
  stdenvNoCC,
  darcs,
  cacert,
  lib,
}:

lib.makeOverridable (
  lib.fetchers.withNormalizedHash { } (
    {
<<<<<<< HEAD
      # Repository to fetch
      url,
      # Additional list of repositories specifying alternative download
      # location to be tried in order, if the prior repository failed to fetch.
      mirrors ? [ ],
=======
      url,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
        url
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        rev
        context
        name
        ;
<<<<<<< HEAD

      repositories = [ url ] ++ mirrors;
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    }
  )
)
