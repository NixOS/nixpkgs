{ fetchArchive }:

{ owner, repo, rev, name ? "source"
, ... # For hash agility
}@args: fetchArchive ({
  inherit name;
  url = "https://bitbucket.org/${owner}/${repo}/get/${rev}.tar.gz";
  meta.homepage = "https://bitbucket.org/${owner}/${repo}/";
} // removeAttrs args [ "owner" "repo" "rev" ]) // { inherit rev; }
