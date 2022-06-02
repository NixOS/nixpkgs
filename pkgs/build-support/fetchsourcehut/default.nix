{ fetchgit, fetchhg, fetchzip, lib }:

{ owner
, repo, rev
, domain ? "sr.ht"
, vc ? "git"
, name ? "source"
, fetchSubmodules ? false
, ... # For hash agility
} @ args:

with lib;

assert (lib.assertOneOf "vc" vc [ "hg" "git" ]);

let
  baseUrl = "https://${vc}.${domain}/${owner}/${repo}";
  baseArgs = {
    inherit name;
  } // removeAttrs args [
    "owner" "repo" "rev" "domain" "vc" "name" "fetchSubmodules"
  ];
  vcArgs = baseArgs // {
    inherit rev;
    url = baseUrl;
  };
  fetcher = if fetchSubmodules then vc else "zip";
  cases = {
    git = {
      fetch = fetchgit;
      arguments = vcArgs // { fetchSubmodules = true; };
    };
    hg = {
      fetch = fetchhg;
      arguments = vcArgs // { fetchSubrepos = true; };
    };
    zip = {
      fetch = fetchzip;
      arguments = baseArgs // {
        url = "${baseUrl}/archive/${rev}.tar.gz";
        postFetch = optionalString (vc == "hg") ''
          rm -f "$out/.hg_archival.txt"
        ''; # impure file; see #12002
      };
    };
  };
in cases.${fetcher}.fetch cases.${fetcher}.arguments // {
  inherit rev;
  meta.homepage = "${baseUrl}";
}
