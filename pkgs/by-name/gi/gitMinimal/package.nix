{
  git,
  stdenv,
  curl,
  curlMinimal,
}:
git.override {
  withManual = false;
  osxkeychainSupport = false;
  pythonSupport = false;
  perlSupport = false;
  rustSupport = false; # Needed for bootstrap
  withpcre2 = false;
  curl = if stdenv.hostPlatform.isFreeBSD then curlMinimal else curl; # Needed for FreeBSD bootstrap
}
