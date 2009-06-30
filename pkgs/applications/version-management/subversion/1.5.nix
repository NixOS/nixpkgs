{ bdbSupport ? false # build support for Berkeley DB repositories
, httpServer ? false # build Apache DAV module
, httpSupport ? false # client must support http
, sslSupport ? false # client must support https
, compressionSupport ? false # client must support http compression
, pythonBindings ? false
, perlBindings ? false
, javahlBindings ? false
, stdenv, fetchurl, apr, aprutil, neon, zlib
, httpd ? null, expat, swig ? null, jdk ? null
, static ? false
}:

assert bdbSupport -> aprutil.bdbSupport;
assert httpServer -> httpd != null;
assert pythonBindings -> swig != null && swig.pythonSupport;
assert javahlBindings -> jdk != null;
assert sslSupport -> neon.sslSupport;
assert compressionSupport -> neon.compressionSupport;

stdenv.mkDerivation rec {

  version = "1.5.6";

  name = "subversion-${version}";

  src = fetchurl {
    url = "http://subversion.tigris.org/downloads/${name}.tar.bz2";
    sha256 = "1hj69zvg6wk6gryaaa1gi896j53633560wkirypdjhyczrszw0gp";
  };

  buildInputs = [zlib apr aprutil]
    ++ stdenv.lib.optional httpSupport neon
    ++ stdenv.lib.optional pythonBindings swig.python
    ++ stdenv.lib.optional perlBindings swig.perl
    ;

  configureFlags = ''
    --disable-keychain
    ${if static then "--disable-shared --enable-all-static" else ""}
    ${if bdbSupport then "--with-berkeley-db" else "--without-berkeley-db"}
    ${if httpServer then "--with-apxs=${httpd}/bin/apxs" else "--without-apxs"}
    ${if pythonBindings || perlBindings then "--with-swig=${swig}" else "--without-swig"}
    ${if javahlBindings then "--enable-javahl --with-jdk=${jdk}" else ""}
    --disable-neon-version-check
  '';

  preBuild = ''
    makeFlagsArray=(APACHE_LIBEXECDIR=$out/modules)
  '';

  postInstall = ''
    ensureDir $out/share/emacs/site-lisp
    cp contrib/client-side/emacs/*.el $out/share/emacs/site-lisp/

    if test "$pythonBindings"; then
        make swig-py swig_pydir=$(toPythonPath $out)/libsvn swig_pydir_extra=$(toPythonPath $out)/svn
        make install-swig-py swig_pydir=$(toPythonPath $out)/libsvn swig_pydir_extra=$(toPythonPath $out)/svn
    fi

    if test "$perlBindings"; then
        make swig-pl-lib
        make install-swig-pl-lib
        cd subversion/bindings/swig/perl/native
        perl Makefile.PL PREFIX=$out
        make install
        cd -
    fi
  ''; # */

  inherit perlBindings pythonBindings;

  meta = {
    description = "A version control system intended to be a compelling replacement for CVS in the open source community";
    homepage = http://subversion.tigris.org/;
  };
}

