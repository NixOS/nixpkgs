{
  lib,
  repoRevToNameMaybe,
  fetchgit,
  fetchhg,
  fetchzip,
}:

let
  inherit (lib)
    assertOneOf
    makeOverridable
    optionalString
    ;
in

makeOverridable (
  {
    owner,
    repo,
    rev ? null,
    tag ? null,
    name ? repoRevToNameMaybe repo (lib.revOrTag rev tag) "sourcehut",
    domain ? "sr.ht",
    vc ? "git",
    fetchSubmodules ? false,
    ... # For hash agility
  }@args:

  assert (
    lib.assertMsg (lib.xor (tag == null) (
      rev == null
    )) "fetchFromSourcehut requires one of either `rev` or `tag` to be provided (not both)."
  );

  assert (
    assertOneOf "vc" vc [
      "hg"
      "git"
    ]
  );

  let
    urlFor = resource: "https://${resource}.${domain}/${owner}/${repo}";
    rev' = if tag != null then tag else rev;
    baseUrl = urlFor vc;
    baseArgs = {
      inherit name;
    }
    // removeAttrs args [
      "owner"
      "repo"
      "rev"
      "tag"
      "domain"
      "vc"
      "name"
      "fetchSubmodules"
    ];
    vcArgs = baseArgs // {
      rev = rev';
      url = baseUrl;
    };
    fetcher = if fetchSubmodules then vc else "zip";
    cases = {
      git = {
        fetch = fetchgit;
        arguments = vcArgs // {
          fetchSubmodules = true;
        };
      };
      hg = {
        fetch = fetchhg;
        arguments = vcArgs // {
          fetchSubrepos = true;
        };
      };
      zip = {
        fetch = fetchzip;
        arguments = baseArgs // {
          url = "${baseUrl}/archive/${rev'}.tar.gz";
          postFetch = optionalString (vc == "hg") ''
            rm -f "$out/.hg_archival.txt"
          ''; # impure file; see #12002
          passthru = (args.passthru or { }) // {
            gitRepoUrl = urlFor "git";
          };
        };
      };
    };
  in
  cases.${fetcher}.fetch cases.${fetcher}.arguments
  // {
    rev = rev';
    meta.homepage = "${baseUrl}";
  }
)
