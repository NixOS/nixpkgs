{ fetchzip }:

{ owner, repo, rev, name ? "source"
, postFetch ? "", zipPostFetch ? null, zipExtraPostFetch ? ""
, ... # For hash agility
}@args: fetchzip ({
  inherit name;
  url = "https://bitbucket.org/${owner}/${repo}/get/${rev}.tar.gz";
  ${if zipPostFetch != null then "postFetch" else null} = zipPostFetch;
  extraPostFetch = postFetch + "\n" + zipExtraPostFetch + "\n" +
    ''rm -f "$out"/.hg_archival.txt''; # impure file; see #12002
} // removeAttrs args [ "owner" "repo" "rev" ]) // {
  meta.homepage = "https://bitbucket.org/${owner}/${repo}/";
  inherit rev;
}
