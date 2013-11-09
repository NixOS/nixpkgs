{ bdbSupport ? false # build support for Berkeley DB repositories
, httpServer ? false # build Apache DAV module
, httpSupport ? false # client must support http
, sslSupport ? false # client must support https
, compressionSupport ? false # client must support http compression
, pythonBindings ? false
, perlBindings ? false
, javahlBindings ? false
, saslSupport ? false
, stdenv, fetchurl, apr, aprutil, neon, zlib, sqlite
, httpd ? null, expat, swig ? null, jdk ? null, python ? null, perl ? null
, sasl ? null
}:

assert bdbSupport -> aprutil.bdbSupport;
assert httpServer -> httpd != null;
assert pythonBindings -> swig != null && python != null;
assert javahlBindings -> jdk != null && perl != null;
assert sslSupport -> neon.sslSupport;
assert compressionSupport -> neon.compressionSupport;

stdenv.mkDerivation rec {

  version = "1.7.13";

  name = "subversion-${version}";

  src = fetchurl {
    url = "mirror://apache/subversion//${name}.tar.bz2";
    sha1 = "844bb756ec505edaa12b9610832bcd21567139f1";
  };

  buildInputs = [ zlib apr aprutil sqlite ]
    ++ stdenv.lib.optional httpSupport neon
    ++ stdenv.lib.optional pythonBindings python
    ++ stdenv.lib.optional perlBindings perl
    ++ stdenv.lib.optional saslSupport sasl;

  configureFlags = ''
    ${if bdbSupport then "--with-berkeley-db" else "--without-berkeley-db"}
    ${if httpServer then "--with-apxs=${httpd}/bin/apxs" else "--without-apxs"}
    ${if pythonBindings || perlBindings then "--with-swig=${swig}" else "--without-swig"}
    ${if javahlBindings then "--enable-javahl --with-jdk=${jdk}" else ""}
    ${if stdenv.isDarwin then "--enable-keychain" else "--disable-keychain"}
    ${if saslSupport then "--enable-sasl --with-sasl=${sasl}" else "--disable-sasl"}
    --with-zlib=${zlib}
    --with-sqlite=${sqlite}
  '';

  preBuild = ''
    makeFlagsArray=(APACHE_LIBEXECDIR=$out/modules)
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace "-no-cpp-precomp" ""
  '';

  postInstall = ''
    if test -n "$pythonBindings"; then
        make swig-py swig_pydir=$(toPythonPath $out)/libsvn swig_pydir_extra=$(toPythonPath $out)/svn
        make install-swig-py swig_pydir=$(toPythonPath $out)/libsvn swig_pydir_extra=$(toPythonPath $out)/svn
    fi

    if test -n "$perlBindings"; then
        make swig-pl-lib
        make install-swig-pl-lib
        cd subversion/bindings/swig/perl/native
        perl Makefile.PL PREFIX=$out
        make install
        cd -
    fi

    mkdir -p $out/share/bash-completion/completions
    cp tools/client-side/bash_completion $out/share/bash-completion/completions/subversion
  '';

  inherit perlBindings pythonBindings;

  enableParallelBuilding = true;

  meta = {
    description = "A version control system intended to be a compelling replacement for CVS in the open source community";
    homepage = http://subversion.apache.org/;
    maintainers = with stdenv.lib.maintainers; [ eelco lovek323 ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
