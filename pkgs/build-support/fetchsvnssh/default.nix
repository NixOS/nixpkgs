{stdenv, subversion, sshSupport ? false, openssh ? null, expect}: 
{username, password, url, rev ? "HEAD", md5 ? "", sha256 ? ""}:


if md5 != "" then
  throw "fetchsvnssh does not support md5 anymore, please use sha256"
else
stdenv.mkDerivation {
  name = "svn-export-ssh";
  builder = ./builder.sh;
  buildInputs = [subversion expect];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  sshSubversion = ./sshsubversion.exp;

  inherit username password url rev sshSupport openssh;
}
