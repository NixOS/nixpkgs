{stdenv, subversion}: {url, rev}: derivation {
  name = "svn-checkout";
  system = stdenv.system;
  builder = ./builder.sh;
  stdenv = stdenv;
  subversion = subversion;
  url = url;
  rev = rev;
}
