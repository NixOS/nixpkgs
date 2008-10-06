{ bdbSupport ? false
, httpServer ? false
, sslSupport ? false
, compressionSupport ? false
, pythonBindings ? false
, perlBindings ? false
, javahlBindings ? false
, stdenv, fetchurl, apr, aprutil, neon, zlib
, httpd ? null, expat, swig ? null, jdk ? null
}:

assert bdbSupport -> aprutil.bdbSupport;
assert httpServer -> httpd != null && httpd.apr == apr && httpd.aprutil == aprutil;
assert pythonBindings -> swig != null && swig.pythonSupport;
assert javahlBindings -> jdk != null;
assert sslSupport -> neon.sslSupport;
assert compressionSupport -> neon.compressionSupport;

stdenv.mkDerivation rec {

  version = "1.4.6"; # attribute version is used within svnmerge as well

  name = "subversion-${version}";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://subversion.tigris.org/downloads/subversion-1.4.6.tar.bz2;
    sha1 = "a9c941e2309744f6a2986200698b60da057a7527";
  };

  buildInputs =
    [expat zlib]
    ++ stdenv.lib.optional pythonBindings swig.python
    ++ stdenv.lib.optional perlBindings swig.perl
    ;

  configureFlags = ''
    --without-gdbm --disable-static
    --with-apr=${apr} -with-apr-util=${aprutil} --with-neon=${neon}
    --disable-keychain
    ${if bdbSupport then "--with-berkeley-db" else "--without-berkeley-db"}
    ${if httpServer then "--with-apxs=${httpd}/bin/apxs" else "--without-apxs"}
    ${if pythonBindings || perlBindings then "--with-swig=${swig}" else "--without-swig"}
    ${if javahlBindings then "--enable-javahl --with-jdk=${jdk}" else ""}
    --disable-neon-version-check
  '';

  inherit httpServer pythonBindings javahlBindings perlBindings;
  
  patches = [ ./subversion-respect_CPPFLAGS_in_perl_bindings.patch ];

  passthru = {
    inherit perlBindings pythonBindings;
    python = if swig != null && swig ? python then swig.python else null;
  };

  meta = {
    description = "A version control system intended to be a compelling replacement for CVS in the open source community";
    homepage = http://subversion.tigris.org/;
  };
}

