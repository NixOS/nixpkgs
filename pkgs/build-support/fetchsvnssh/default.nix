{lib, stdenvNoCC, subversion, sshSupport ? true, openssh ? null, expect}:
{username, password
, url, rev ? "HEAD"
, outputHash ? lib.fakeHash, outputHashAlgo ? null}:

lib.fetchers.withNormalizedHash { } (
  stdenvNoCC.mkDerivation {
    name = "svn-export-ssh";
    builder = ./builder.sh;
    nativeBuildInputs = [subversion expect];

    inherit outputHash outputHashAlgo;
    outputHashMode = "recursive";

    sshSubversion = ./sshsubversion.exp;

    inherit username password url rev sshSupport openssh;
  }
)
