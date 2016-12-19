{stdenv, subversion, sshSupport ? false, openssh ? null, expect}: 
{username, password, url, rev ? "HEAD", md5 ? "", sha256 ? ""}:

stdenv.mkDerivation {
  name = "svn-export-ssh";
  builder = ./builder.sh;
  buildInputs = [subversion expect];

  outputHashAlgo = if sha256 == "" then "md5" else "sha256";
  outputHashMode = "recursive";
  outputHash = if sha256 == "" then md5 else sha256;
  
  sshSubversion = ./sshsubversion.exp;
  
  inherit username password url rev sshSupport openssh;
}
