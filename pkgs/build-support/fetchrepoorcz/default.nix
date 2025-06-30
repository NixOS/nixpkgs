{
  lib,
  repoRevToNameMaybe,
  fetchzip,
}:

# gitweb example, snapshot support is optional in gitweb
{
  repo,
  rev,
  name ? repoRevToNameMaybe repo rev "repoorcz",
  ... # For hash agility
}@args:
fetchzip (
  {
    inherit name;
    url = "https://repo.or.cz/${repo}.git/snapshot/${rev}.tar.gz";
    meta.homepage = "https://repo.or.cz/${repo}.git/";
  }
  // removeAttrs args [
    "repo"
    "rev"
  ]
)
// {
  inherit rev;
}
