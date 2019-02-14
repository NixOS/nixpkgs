{ bdbSupport ? true # build support for Berkeley DB repositories
, httpServer ? false # build Apache DAV module
, httpSupport ? true # client must support http
, pythonBindings ? false
, perlBindings ? false
, javahlBindings ? false
, saslSupport ? false
, stdenv, fetchurl, apr, aprutil, zlib, sqlite, openssl, lz4, utf8proc
, apacheHttpd ? null, expat, swig ? null, jdk ? null, python ? null, perl ? null
, sasl ? null, serf ? null
}:

assert bdbSupport -> aprutil.bdbSupport;
assert httpServer -> apacheHttpd != null;
assert pythonBindings -> swig != null && python != null;
assert javahlBindings -> jdk != null && perl != null;

let

  common = { version, sha256, extraBuildInputs ? [ ] }: stdenv.mkDerivation (rec {
    inherit version;
    name = "subversion-${version}";

    src = fetchurl {
      url = "mirror://apache/subversion/${name}.tar.bz2";
      inherit sha256;
    };

    # Can't do separate $lib and $bin, as libs reference bins
    outputs = [ "out" "dev" "man" ];

    buildInputs = [ zlib apr aprutil sqlite openssl ]
      ++ extraBuildInputs
      ++ stdenv.lib.optional httpSupport serf
      ++ stdenv.lib.optional pythonBindings python
      ++ stdenv.lib.optional perlBindings perl
      ++ stdenv.lib.optional saslSupport sasl;

    patches = [ ./apr-1.patch ];

    # SVN build seems broken on gcc5:
    # https://gcc.gnu.org/gcc-5/porting_to.html
    CPPFLAGS = "-P";

    configureFlags = [
      (stdenv.lib.withFeature bdbSupport "berkeley-db")
      (stdenv.lib.withFeatureAs httpServer "apxs" "${apacheHttpd.dev}/bin/apxs")
      (stdenv.lib.withFeatureAs (pythonBindings || perlBindings) "swig" swig)
      (stdenv.lib.withFeatureAs saslSupport "sasl" sasl)
      (stdenv.lib.withFeatureAs httpSupport "serf" serf)
      "--disable-keychain"
      "--with-zlib=${zlib.dev}"
      "--with-sqlite=${sqlite.dev}"
    ] ++ stdenv.lib.optionals javahlBindings [
      "--enable-javahl"
      "--with-jdk=${jdk}"
    ];

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

      for f in $out/lib/*.la $out/lib/python*/site-packages/*/*.la; do
        substituteInPlace $f \
          --replace "${expat.dev}/lib" "${expat.out}/lib" \
          --replace "${zlib.dev}/lib" "${zlib.out}/lib" \
          --replace "${sqlite.dev}/lib" "${sqlite.out}/lib" \
          --replace "${openssl.dev}/lib" "${openssl.out}/lib"
      done
    '';

    inherit perlBindings pythonBindings;

    enableParallelBuilding = true;

    checkInputs = [ python ];
    doCheck = false; # fails 10 out of ~2300 tests

    meta = with stdenv.lib; {
      description = "A version control system intended to be a compelling replacement for CVS in the open source community";
      license = licenses.asl20;
      homepage = http://subversion.apache.org/;
      maintainers = with maintainers; [ eelco lovek323 ];
      platforms = platforms.linux ++ platforms.darwin;
    };

  } // stdenv.lib.optionalAttrs stdenv.isDarwin {
    CXX = "clang++";
    CC = "clang";
    CPP = "clang -E";
    CXXCPP = "clang++ -E";
  });

in {
  subversion18 = common {
    version = "1.8.19";
    sha256 = "1gp6426gkdza6ni2whgifjcmjb4nq34ljy07yxkrhlarvfq6ks2n";
  };

  subversion19 = common {
    version = "1.9.9";
    sha256 = "1ll13ychbkp367c7zsrrpda5nygkryma5k18qfr8wbaq7dbvxzcd";
  };

  subversion_1_10 = common {
    version = "1.10.3";
    sha256 = "1z6r3n91a4znsh68rl3jisfr7k4faymhbpalmmvsmvsap34al3cz";
    extraBuildInputs = [ lz4 utf8proc ];
  };

  subversion_1_11 = common {
    version = "1.11.1";
    sha256 = "1fv0psjxx5nxb4zmddyrma2bnv1bfff4p8ii6j8fqwjdr982gzcy";
    extraBuildInputs = [ lz4 utf8proc ];
  };
}
