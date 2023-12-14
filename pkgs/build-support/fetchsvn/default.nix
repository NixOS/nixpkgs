{ lib, stdenvNoCC, buildPackages
, subversion, glibcLocales, sshSupport ? true, openssh ? null
}:

{ url, rev ? "HEAD", sha256 ? "", hash ? ""
, ignoreExternals ? false, ignoreKeywords ? false, name ? null
, preferLocalBuild ? true
}:

assert sshSupport -> openssh != null;

let
  repoName = with lib;
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

if hash != "" && sha256 != "" then
  throw "Only one of sha256 or hash can be set"
else
stdenvNoCC.mkDerivation {
  name = name_;
  builder = ./builder.sh;
  nativeBuildInputs = [ subversion glibcLocales ]
    ++ lib.optional sshSupport openssh;

  SVN_SSH = if sshSupport then "${buildPackages.openssh}/bin/ssh" else null;

  outputHashAlgo = if hash != "" then null else "sha256";
  outputHashMode = "recursive";
  outputHash = if hash != "" then
    hash
  else if sha256 != "" then
    sha256
  else
    lib.fakeSha256;

  inherit url rev ignoreExternals ignoreKeywords;

  impureEnvVars = lib.fetchers.proxyImpureEnvVars;
  inherit preferLocalBuild;
}
