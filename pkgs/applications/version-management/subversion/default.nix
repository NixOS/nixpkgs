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

  common = { version, sha256, extraBuildInputs ? [ ], extraPatches ? [ ], knownVulnerabilities ? [ ] }: stdenv.mkDerivation (rec {
    inherit version;
    pname = "subversion";

    src = fetchurl {
      url = "mirror://apache/subversion/${pname}-${version}.tar.bz2";
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

    patches = [ ./apr-1.patch ] ++ extraPatches;

    # We are hitting the following issue even with APR 1.6.x
    # -> https://issues.apache.org/jira/browse/SVN-4813
    # "-P" CPPFLAG is needed to build Python bindings and subversionClient
    CPPFLAGS = [ "-P" ];

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
      homepage = "http://subversion.apache.org/";
      maintainers = with maintainers; [ eelco lovek323 ];
      platforms = platforms.linux ++ platforms.darwin;
      inherit knownVulnerabilities;
    };

  } // stdenv.lib.optionalAttrs stdenv.isDarwin {
    CXX = "clang++";
    CC = "clang";
    CPP = "clang -E";
    CXXCPP = "clang++ -E";
  });

in {
  subversion19 = common {
    version = "1.9.12";
    sha256 = "15z33gdnfiqblm5515020wfdwnp2837r3hnparava6m2fgyiafiw";
    knownVulnerabilities = [
      "https://subversion.apache.org/security/CVE-2020-17525-advisory.txt"
    ];
  };

  subversion_1_10 = common {
    version = "1.10.7";
    sha256 = "1nhrd8z6c94sc0ryrzpyd98qdn5a5g3x0xv1kdb9da4drrk8y2ww";
    extraBuildInputs = [ lz4 utf8proc ];
  };

  subversion = common {
    version = "1.12.2";
    sha256 = "0wgpw3kzsiawzqk4y0xgh1z93kllxydgv4lsviim45y5wk4bbl1v";
    extraBuildInputs = [ lz4 utf8proc ];
    extraPatches = [ ./CVE-2020-17525.patch ];
  };
}
