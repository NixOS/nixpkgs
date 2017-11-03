{stdenv, subversion, glibcLocales, sshSupport ? false, openssh ? null}:
{url, rev ? "HEAD", md5 ? "", sha256 ? "",
 ignoreExternals ? false, ignoreKeywords ? false, name ? null}:

let
  repoName = with stdenv.lib;
    let
      fst = head;
      snd = l: head (tail l);
      trd = l: head (tail (tail l));
      path_ =
        (p: if head p == "" then tail p else p) # ~ drop final slash if any
        (reverseList (splitString "/" url));
      path = [ (removeSuffix "/" (head path_)) ] ++ (tail path_);
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

if md5 != "" then
  throw "fetchsvn does not support md5 anymore, please use sha256"
else
stdenv.mkDerivation {
  name = name_;
  builder = ./builder.sh;
  buildInputs = [ subversion glibcLocales ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  inherit url rev sshSupport openssh ignoreExternals ignoreKeywords;

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
  preferLocalBuild = true;
}
