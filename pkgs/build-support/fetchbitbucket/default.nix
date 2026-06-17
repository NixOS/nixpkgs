{
  lib,
  repoRevToNameMaybe,
  fetchgit,
  fetchzip,
}:

lib.makeOverridable (
  {
    owner,
    repo,
    tag ? null,
    rev ? null,
    name ? repoRevToNameMaybe repo (lib.revOrTag rev tag) "bitbucket",
    fetchSubmodules ? false,
    leaveDotGit ? false,
    deepClone ? false,
    forceFetchGit ? false,
    fetchLFS ? false,
    rootDir ? "",
    sparseCheckout ? lib.optional (rootDir != "") rootDir,
    meta ? { },
    ... # For hash agility
  }@args:

  assert (
    lib.assertMsg (lib.xor (tag == null) (
      rev == null
    )) "fetchFromBitbucket requires one of either `rev` or `tag` to be provided (not both)."
  );

  let
    position = (
      if args.meta.description or null != null then
        builtins.unsafeGetAttrPos "description" args.meta
      else if tag != null then
        builtins.unsafeGetAttrPos "tag" args
      else
        builtins.unsafeGetAttrPos "rev" args
    );
    baseUrl = "https://bitbucket.org/${owner}/${repo}";
    newMeta =
      meta
      // {
        homepage = meta.homepage or baseUrl;
      }
      // lib.optionalAttrs (position != null) {
        # to indicate where derivation originates, similar to make-derivation.nix's mkDerivation
        position = "${position.file}:${toString position.line}";
      };
    gitRepoUrl = "${baseUrl}.git";

    # the tag is escaped to support mercurial-based tags as bitbucket supports them
    revWithTag = if tag != null then "refs/tags/${lib.strings.escapeURL tag}" else rev;

    passthruAttrs = removeAttrs args [
      "owner"
      "repo"
      "rev"
      "tag"
      "fetchSubmodules"
      "forceFetchGit"
    ];

    useFetchGit =
      fetchSubmodules
      || (leaveDotGit == true)
      || deepClone
      || forceFetchGit
      || fetchLFS
      || (rootDir != "")
      || (sparseCheckout != [ ]);

    fetcher = if useFetchGit then fetchgit else fetchzip;

    fetcherArgs =
      (
        if useFetchGit then
          {
            inherit
              rev
              tag
              deepClone
              fetchSubmodules
              sparseCheckout
              fetchLFS
              ;
            url = gitRepoUrl;
          }
          // lib.optionalAttrs (leaveDotGit != null) { inherit leaveDotGit; }
        else
          {
            url = "https://bitbucket.org/${owner}/${repo}/get/${revWithTag}.tar.gz";
            extension = "tar.gz";
            passthru = {
              inherit gitRepoUrl;
            };
          }
      )
      // passthruAttrs
      // {
        inherit name;
      };
  in
  fetcher fetcherArgs
  // {
    meta = newMeta;
    inherit owner repo tag;
    rev = revWithTag;
  }
)
