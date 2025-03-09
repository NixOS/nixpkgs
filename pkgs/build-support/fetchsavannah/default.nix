{ fetchzip, lib }:

lib.makeOverridable (
  # cgit example, snapshot support is optional in cgit
  {
    repo,
    rev,
    name ? "source",
    ... # For hash agility
  }@args:
  fetchzip (
    {
      inherit name;
      url = "https://git.savannah.gnu.org/cgit/${repo}.git/snapshot/${repo}-${rev}.tar.gz";
      meta.homepage = "https://git.savannah.gnu.org/cgit/${repo}.git/";
      passthru.gitRepoUrl = "https://git.savannah.gnu.org/git/${repo}.git";
    }
    // removeAttrs args [
      "repo"
      "rev"
    ]
  )
  // {
    inherit rev;
  }
)
