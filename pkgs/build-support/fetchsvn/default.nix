{stdenv, subversion, nix}: {url, rev ? "HEAD", md5}:

stdenv.mkDerivation {
  name = "svn-export";
  builder = ./builder.sh;
  buildInputs = [subversion nix];
  id = md5;
  inherit url rev md5;
}
