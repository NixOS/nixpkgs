{lib, stdenvNoCC, git, git-lfs, cacert}: let
  urlToName = url: rev: let
    inherit (lib) removeSuffix splitString last;
    base = last (splitString ":" (baseNameOf (removeSuffix "/" url)));

    matched = builtins.match "(.*).git" base;

    short = builtins.substring 0 7 rev;

    appendShort = if (builtins.match "[a-f0-9]*" rev) != null
      then "-${short}"
      else "";
  in "${if matched == null then base else builtins.head matched}${appendShort}";
in
{ url
, rev ? "HEAD"

, # SRI hash.
  hash ? ""

, # Legacy ways of specifying the hash.
  outputHash ? ""
, outputHashAlgo ? ""
, md5 ? ""
, sha1 ? ""
, sha256 ? ""
, sha512 ? ""

, # Git-related options.
  leaveDotGit ? deepClone
, fetchSubmodules ? true, deepClone ? false
, branchName ? null
, name ? urlToName url rev
, # Shell code executed after the file has been fetched
  # successfully. This can do things like check or transform the file.
  postFetch ? ""
, preferLocalBuild ? true
, fetchLFS ? false
}:

/* NOTE:
   fetchgit has one problem: git fetch only works for refs.
   This is because fetching arbitrary (maybe dangling) commits may be a security risk
   and checking whether a commit belongs to a ref is expensive. This may
   change in the future when some caching is added to git (?)
   Usually refs are either tags (refs/tags/*) or branches (refs/heads/*)
   Cloning branches will make the hash check fail when there is an update.
   But not all patches we want can be accessed by tags.

   The workaround is getting the last n commits so that it's likely that they
   still contain the hash we want.

   for now : increase depth iteratively (TODO)

   real fix: ask git folks to add a
   git fetch $HASH contained in $BRANCH
   facility because checking that $HASH is contained in $BRANCH is less
   expensive than fetching --depth $N.
   Even if git folks implemented this feature soon it may take years until
   server admins start using the new version?
*/

assert deepClone -> leaveDotGit;

let
  hash_ =
    if hash != "" then { outputHashAlgo = null; outputHash = hash; }
    else if md5 != "" then throw "fetchgit does not support md5 anymore, please use hash (in SRI format), sha256 or sha512 attribute"
    else if (outputHash != "" && outputHashAlgo != "") then { inherit outputHashAlgo outputHash; }
    else if sha512 != "" then { outputHashAlgo = "sha512"; outputHash = sha512; }
    else if sha256 != "" then { outputHashAlgo = "sha256"; outputHash = sha256; }
    else if sha1   != "" then { outputHashAlgo = "sha1";   outputHash = sha1; }
    else throw "fetchgit requires a hash for fixed-output derivation: ${url} @ ${rev}";
in stdenvNoCC.mkDerivation {
  inherit name;
  builder = ./builder.sh;
  fetcher = ./nix-prefetch-git;  # This must be a string to ensure it's called with bash.

  nativeBuildInputs = [ git ]
    ++ lib.optionals fetchLFS [ git-lfs ];

  inherit (hash_) outputHashAlgo outputHash;
  outputHashMode = "recursive";

  inherit url rev leaveDotGit fetchLFS fetchSubmodules deepClone branchName postFetch;

  GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
    "GIT_PROXY_COMMAND" "SOCKS_SERVER"
  ];

  inherit preferLocalBuild;
}
