{
  git,
  stdenv,
  curl,
  curlMinimal,
  ...
}@args:
git.override (
  {
    withManual = false;
    osxkeychainSupport = false;
    pythonSupport = false;
    perlSupport = false;
    rustSupport = false; # Needed for bootstrap
    withpcre2 = false;
    curl = if stdenv.hostPlatform.isFreeBSD then curlMinimal else curl; # Needed for FreeBSD bootstrap
  }
  // removeAttrs args [
    "git"
    "curl"
    "curlMinimal"
  ]
)
