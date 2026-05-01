{
  lib,
  stdenvNoCC,
  buildPackages,
  cacert,
  subversion,
  glibcLocales,
  sshSupport ? true,
  openssh ? null,
}:

let
  repoToName =
    url: rev:
    let
      inherit (lib)
        removeSuffix
        splitString
        reverseList
        head
        last
        elemAt
        ;
      base = removeSuffix "/" (last (splitString ":" url));
      pathParts = reverseList (splitString "/" base);
      repoName =
        # ../repo/trunk -> repo
        if head pathParts == "trunk" then
          elemAt pathParts 1
        # ../repo/branches/branch -> repo-branch
        else if elemAt pathParts 1 == "branches" then
          "${elemAt pathParts 2}-${head pathParts}"
        # ../repo/tags/tag -> repo-tag
        else if elemAt pathParts 1 == "tags" then
          "${elemAt pathParts 2}-${head pathParts}"
        # ../repo (no trunk) -> repo
        else
          head pathParts;
    in
    "${repoName}-r${toString rev}";

  # Constructs the final URL from base url, path, and tag.
  # - If `tag` is set, appends `/tags/${tag}` to the URL
  # - Otherwise, appends `/${path}` if path is not empty
  getFullUrl =
    {
      url,
      path ? "",
      tag ? null,
    }:
    let
      baseUrl = lib.removeSuffix "/" url;
    in
    if tag != null then
      "${baseUrl}/tags/${tag}"
    else if path != "" then
      "${baseUrl}/${path}"
    else
      url;
in

{
  url,
  # Subdirectory path within the repository (e.g., "trunk", "branches/foo").
  # Ignored if `tag` is set.
  path ? "",
  # Tag name to fetch. Sets path to "tags/${tag}".
  # Mutually exclusive with `path`.
  tag ? null,
  rev ? "HEAD",
  name ? repoToName (getFullUrl { inherit url path tag; }) rev,
  sha256 ? "",
  hash ? "",
  ignoreExternals ? false,
  ignoreKeywords ? false,
  preferLocalBuild ? true,
}:

assert tag == null || path == "" || throw "fetchsvn: `tag` and `path` are mutually exclusive";

assert sshSupport -> openssh != null;

if hash != "" && sha256 != "" then
  throw "Only one of sha256 or hash can be set"
else
  stdenvNoCC.mkDerivation {
    inherit name;
    builder = ./builder.sh;
    nativeBuildInputs = [
      cacert
      subversion
      glibcLocales
    ]
    ++ lib.optional sshSupport openssh;

    SVN_SSH = if sshSupport then "${buildPackages.openssh}/bin/ssh" else null;

    outputHashAlgo = if hash != "" then null else "sha256";
    outputHashMode = "recursive";
    outputHash =
      if hash != "" then
        hash
      else if sha256 != "" then
        sha256
      else
        lib.fakeSha256;

    url = getFullUrl { inherit url path tag; };

    inherit
      rev
      ignoreExternals
      ignoreKeywords
      ;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars;
    inherit preferLocalBuild;
  }
