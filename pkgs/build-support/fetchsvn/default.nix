{stdenv, subversion, sshSupport ? false, openssh ? null}: 
{url, rev ? "HEAD", md5 ? "", sha256 ? ""}:

stdenv.mkDerivation {
  name = "svn-export";
  builder = ./builder.sh;
  buildInputs = [subversion];

  outputHashAlgo = if sha256 == "" then "md5" else "sha256";
  outputHashMode = "recursive";
  outputHash = if sha256 == "" then md5 else sha256;
  
  inherit url rev sshSupport openssh;
}
