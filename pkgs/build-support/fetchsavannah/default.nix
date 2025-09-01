{
  lib,
  repoRevToNameMaybe,
  fetchzip,
}:

lib.makeOverridable (
  # cgit example, snapshot support is optional in cgit
  {
    repo,
    rev,
    name ? repoRevToNameMaybe repo rev "savannah",
    ... # For hash agility
  }@args:
  fetchzip (
    {
      inherit name;
      url =
        let
          repo' = lib.last (lib.strings.splitString "/" repo); # support repo like emacs/elpa
        in
        "https://cgit.git.savannah.gnu.org/cgit/${repo}.git/snapshot/${repo'}-${rev}.tar.gz";
      meta.homepage = "https://cgit.git.savannah.gnu.org/cgit/${repo}.git/";
      passthru.gitRepoUrl = "https://cgit.git.savannah.gnu.org/git/${repo}.git";
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
