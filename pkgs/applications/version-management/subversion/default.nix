{ bdbSupport ? false # build support for Berkeley DB repositories
, httpServer ? false # build Apache DAV module
, httpSupport ? false # client must support http
, pythonBindings ? false
, perlBindings ? false
, javahlBindings ? false
, saslSupport ? false
, stdenv, fetchurl, apr, aprutil, zlib, sqlite
, apacheHttpd ? null, expat, swig ? null, jdk ? null, python ? null, perl ? null
, sasl ? null, serf ? null
, branch ? "1.9"
}:

assert bdbSupport -> aprutil.bdbSupport;
assert httpServer -> apacheHttpd != null;
assert pythonBindings -> swig != null && python != null;
assert javahlBindings -> jdk != null && perl != null;

let
  config = {
    "1.9".ver_min = "2";
    "1.9".sha1 = "fb9db3b7ddf48ae37aa8785872301b59bfcc7017";

    "1.8".ver_min = "14";
    "1.8".sha1 = "0698efc58373e7657f6dd3ce13cab7b002ffb497";
  };
in
assert builtins.hasAttr branch config;

stdenv.mkDerivation (rec {

  version = "${branch}." + config.${branch}.ver_min;

  name = "subversion-${version}";

  src = fetchurl {
    url = "mirror://apache/subversion/${name}.tar.bz2";
    inherit (config.${branch}) sha1;
  };

  # Can't do separate $lib and $bin, as libs reference bins
  outputs = [ "dev" "out" "man" ];

  buildInputs = [ zlib apr aprutil sqlite ]
    ++ stdenv.lib.optional httpSupport serf
    ++ stdenv.lib.optional pythonBindings python
    ++ stdenv.lib.optional perlBindings perl
    ++ stdenv.lib.optional saslSupport sasl;

  configureFlags = ''
    ${if bdbSupport then "--with-berkeley-db" else "--without-berkeley-db"}
    ${if httpServer then "--with-apxs=${apacheHttpd}/bin/apxs" else "--without-apxs"}
    ${if pythonBindings || perlBindings then "--with-swig=${swig}" else "--without-swig"}
    ${if javahlBindings then "--enable-javahl --with-jdk=${jdk}" else ""}
    --disable-keychain
    ${if saslSupport then "--with-sasl=${sasl}" else "--without-sasl"}
    ${if httpSupport then "--with-serf=${serf}" else "--without-serf"}
    --with-zlib=${zlib}
    --with-sqlite=${sqlite}
  '';

  preBuild = ''
    makeFlagsArray=(APACHE_LIBEXECDIR=$out/modules)
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

    for f in $out/lib/*.la; do
      substituteInPlace $f --replace "${expat.dev}/lib" "${expat.out}/lib"
      substituteInPlace $f --replace "${zlib.dev}/lib" "${zlib.out}/lib"
      substituteInPlace $f --replace "${sqlite.dev}/lib" "${sqlite.out}/lib"
    done
  '';

  inherit perlBindings pythonBindings;

  enableParallelBuilding = true;

  meta = {
    description = "A version control system intended to be a compelling replacement for CVS in the open source community";
    homepage = http://subversion.apache.org/;
    maintainers = with stdenv.lib.maintainers; [ eelco lovek323 ];
    hydraPlatforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
} // stdenv.lib.optionalAttrs stdenv.isDarwin {
  CXX = "clang++";
  CC = "clang";
  CPP = "clang -E";
  CXXCPP = "clang++ -E";
})
