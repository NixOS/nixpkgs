{ fetchzip, lib }:

lib.makeOverridable (
  {
    owner,
    repo,
    rev,
    name ? "source",
    ... # For hash agility
  }@args:
  fetchzip (
    {
      inherit name;
      url = "https://bitbucket.org/${owner}/${repo}/get/${rev}.tar.gz";
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
