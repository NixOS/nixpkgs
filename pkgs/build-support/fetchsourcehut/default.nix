{ fetchzip, lib }:

{ owner
, repo, rev
, domain ? "sr.ht"
, vc ? "git"
, name ? "source"
, ... # For hash agility
} @ args:

with lib;

assert (lib.assertOneOf "vc" vc [ "hg" "git" ]);

let
  baseUrl = "https://${vc}.${domain}/${owner}/${repo}";

in fetchzip (recursiveUpdate {
  inherit name;
  url = "${baseUrl}/archive/${rev}.tar.gz";
  meta.homepage = "${baseUrl}/";
  extraPostFetch = optionalString (vc == "hg") ''
    rm -f "$out/.hg_archival.txt"
  ''; # impure file; see #12002
} (removeAttrs args [ "owner" "repo" "rev" "domain" "vc" ])) // { inherit rev; }
