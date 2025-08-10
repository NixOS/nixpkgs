{
  lib,
  repoRevToNameMaybe,
  fetchzip,
}:

lib.makeOverridable (
  {
    owner,
    repo,
    rev,
    name ? repoRevToNameMaybe repo rev "bitbucket",
    ... # For hash agility
  }@args:
  fetchzip (
    {
      inherit name;
      url = "https://bitbucket.org/${owner}/${repo}/get/${lib.strings.escapeURL rev}.tar.gz";
      meta.homepage = "https://bitbucket.org/${owner}/${repo}/";
    }
    // removeAttrs args [
      "owner"
      "repo"
      "rev"
    ]
  )
  // {
    inherit rev;
  }
)
