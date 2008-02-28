{stdenv, subversion, nix, sshSupport ? false, openssh ? null}: 
{url, rev ? "HEAD", md5 ? "", sha256 ? ""}:

stdenv.mkDerivation {
  name = "svn-export";
  builder = ./builder.sh;
  buildInputs = [subversion nix];

  # Nix <= 0.7 compatibility.
  /*id = if sha256 == "" then md5 else sha256;*/

  outputHashAlgo = if sha256 == "" then "md5" else "sha256";
  outputHashMode = "recursive";
  outputHash = if sha256 == "" then md5 else sha256;
  
  inherit url rev sshSupport openssh;
}
