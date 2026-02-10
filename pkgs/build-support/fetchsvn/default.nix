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
  # Derive a base derivation name from a SVN URL. Examples:
  #   svn://h/repo/trunk          -> repo
  #   svn://h/repo/branches/foo   -> repo-foo
  #   svn://h/repo/tags/v1.0      -> repo-v1.0
  #   svn://h/repo                -> repo
  repoBaseName =
    url:
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
    in
    if head pathParts == "trunk" then
      elemAt pathParts 1
    else if elemAt pathParts 1 == "branches" then
      "${elemAt pathParts 2}-${head pathParts}"
    else if elemAt pathParts 1 == "tags" then
      "${elemAt pathParts 2}-${head pathParts}"
    else
      head pathParts;
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
  name ? null,
  sha256 ? "",
  hash ? "",
  ignoreExternals ? false,
  ignoreKeywords ? false,
  preferLocalBuild ? true,
}:

assert tag == null || path == "" || throw "fetchsvn: `tag` and `path` are mutually exclusive";

assert sshSupport -> openssh != null;

let
  # The final URL: appends `/tags/${tag}` if `tag` is set, otherwise
  # `/${path}` when `path` is non-empty, otherwise the url unchanged.
  fullURL =
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

if hash != "" && sha256 != "" then
  throw "Only one of sha256 or hash can be set"
else
  stdenvNoCC.mkDerivation {
    # When `tag` pins the snapshot, omit the `-r${rev}` suffix — the tag
    # already uniquely identifies the build, so `repo-v1.0-rHEAD` would be noise.
    name =
      if name != null then
        name
      else if tag != null then
        repoBaseName fullURL
      else
        "${repoBaseName fullURL}-r${toString rev}";
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

    url = fullURL;

    inherit
      rev
      ignoreExternals
      ignoreKeywords
      ;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars;
    inherit preferLocalBuild;
  }
