{stdenv, subversion, sshSupport ? false, openssh ? null}:
{url, rev ? "HEAD", md5 ? "", sha256 ? "", ignoreExternals ? false, name ? null}:

let
  repoName = with stdenv.lib;
    let
      fst = head;
      snd = l: head (tail l);
      trd = l: head (tail (tail l));
      path_ = reverseList (splitString "/" url);
      path = if head path_ == "" then tail path_ else path_;
    in
      # ../repo/trunk -> repo
      if fst path == "trunk" then snd path
      # ../repo/branches/branch -> repo-branch
      else if snd path == "branches" then "${trd path}-${fst path}"
      # ../repo/tags/tag -> repo-tag
      else if snd path == "tags" then     "${trd path}-${fst path}"
      # ../repo (no trunk) -> repo
      else fst path;

  name_ = if name == null then "${repoName}-r${toString rev}" else name;
in

stdenv.mkDerivation {
  name = name_;
  builder = ./builder.sh;
  buildInputs = [subversion];

  outputHashAlgo = if sha256 == "" then "md5" else "sha256";
  outputHashMode = "recursive";
  outputHash = if sha256 == "" then md5 else sha256;
  
  inherit url rev sshSupport openssh ignoreExternals;

  impureEnvVars = [
    # We borrow these environment variables from the caller to allow
    # easy proxy configuration.  This is impure, but a fixed-output
    # derivation like fetchurl is allowed to do so since its result is
    # by definition pure.
    "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"
    ];

  preferLocalBuild = true;
}
