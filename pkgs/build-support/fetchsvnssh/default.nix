{stdenvNoCC, subversion, sshSupport ? true, openssh ? null, expect}:
<<<<<<< HEAD
{username, password, url, rev ? "HEAD", sha256 ? ""}:


=======
{username, password, url, rev ? "HEAD", md5 ? "", sha256 ? ""}:


if md5 != "" then
  throw "fetchsvnssh does not support md5 anymore, please use sha256"
else
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
