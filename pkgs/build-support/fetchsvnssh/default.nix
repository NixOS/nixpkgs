{stdenvNoCC, subversion, sshSupport ? true, openssh ? null, expect}:
{username, password, url, rev ? "HEAD", md5 ? "", sha256 ? ""}:


if md5 != "" then
  throw "fetchsvnssh does not support md5 anymore, please use sha256"
else
stdenvNoCC.mkDerivation {
  name = "svn-export-ssh";
  builder = ./builder.sh;
  nativeBuildInputs = [subversion expect];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  sshSubversion = ./sshsubversion.exp;

  inherit username password url rev sshSupport openssh;
}
