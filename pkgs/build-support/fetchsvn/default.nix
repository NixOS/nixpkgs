{stdenv, subversion}: {url, rev}: stdenv.mkDerivation {
  name = "svn-checkout";
  builder = ./builder.sh;
  subversion = subversion;
  url = url;
  rev = rev;
}
