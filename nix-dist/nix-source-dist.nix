{ stdenv, autoconf, automake, libxml2, libxslt
, docbook_dtd, docbook_xslt
, fetchurl, fetchsvn, rev
}:

derivation {
  name = "nix-source-dist";
  system = stdenv.system;

  builder = ./nix-source-dist.sh;
  src = fetchsvn {
    url = "https://svn.cs.uu.nl:12443/repos/trace/nix/trunk/";
    rev = rev;
  };

  bdbSrc = fetchurl {
    url = "http://www.sleepycat.com/update/snapshot/db-4.1.25.tar.gz";
    md5 = "df71961002b552c0e72c6e4e358f27e1";
  };

  atermSrc = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/aterm/aterm-2.0.5.tar.gz;
    md5 = "68aefb0c10b2ab876b8d3c0b2d0cdb1b";
  };

  sdfSrc = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/sdf2/sdf2-bundle-1.6.tar.gz;
    md5 = "283be0b4c7c9575c1b5cc735316e6192";
  };

  stdenv = stdenv;
  autoconf = autoconf;
  automake = automake;
  libxml2 = libxml2;
  libxslt = libxslt;
  docbook_dtd = docbook_dtd;
  docbook_xslt = docbook_xslt;
}
