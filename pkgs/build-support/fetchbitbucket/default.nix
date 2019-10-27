{ fetchzip }:

{ owner, repo, rev, name ? "source"
, ... # For hash agility
}@args: fetchzip ({
  inherit name;
  url = "https://bitbucket.org/${owner}/${repo}/get/${rev}.tar.gz";
  meta.homepage = "https://bitbucket.org/${owner}/${repo}/";
  extraPostFetch = ''rm -f "$out"/.hg_archival.txt''; # impure file; see #12002
} // removeAttrs args [ "owner" "repo" "rev" ]) // { inherit rev; }
