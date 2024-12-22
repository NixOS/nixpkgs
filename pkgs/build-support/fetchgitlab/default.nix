{
  lib,
  fetchgit,
  fetchzip,
}:

lib.makeOverridable (
  # gitlab example
  {
    owner,
    repo,
    rev ? null,
    tag ? null,
    protocol ? "https",
    domain ? "gitlab.com",
    name ? "source",
    group ? null,
    fetchSubmodules ? false,
    leaveDotGit ? false,
    deepClone ? false,
    forceFetchGit ? false,
    sparseCheckout ? [ ],
    ... # For hash agility
  }@args:

  assert (
    lib.assertMsg (lib.xor (tag == null) (
      rev == null
    )) "fetchFromGitLab requires one of either `rev` or `tag` to be provided (not both)."
  );

  let
    slug = lib.concatStringsSep "/" (
      (lib.optional (group != null) group)
      ++ [
        owner
        repo
      ]
    );
    escapedSlug = lib.replaceStrings [ "." "/" ] [ "%2E" "%2F" ] slug;
    escapedRev = lib.replaceStrings [ "+" "%" "/" ] [ "%2B" "%25" "%2F" ] (
      if tag != null then "refs/tags/" + tag else rev
    );
    passthruAttrs = removeAttrs args [
      "protocol"
      "domain"
      "owner"
      "group"
      "repo"
      "rev"
      "tag"
      "fetchSubmodules"
      "forceFetchGit"
      "leaveDotGit"
      "deepClone"
    ];

    useFetchGit =
      fetchSubmodules || leaveDotGit || deepClone || forceFetchGit || (sparseCheckout != [ ]);
    fetcher = if useFetchGit then fetchgit else fetchzip;

    gitRepoUrl = "${protocol}://${domain}/${slug}.git";

    fetcherArgs =
      (
        if useFetchGit then
          {
            inherit
              rev
              deepClone
              tag
              fetchSubmodules
              sparseCheckout
              leaveDotGit
              ;
            url = gitRepoUrl;
          }
        else
          {
            url = "${protocol}://${domain}/api/v4/projects/${escapedSlug}/repository/archive.tar.gz?sha=${escapedRev}";

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
    meta.homepage = "${protocol}://${domain}/${slug}/";
    inherit
      tag
      rev
      owner
      repo
      ;
  }
)
