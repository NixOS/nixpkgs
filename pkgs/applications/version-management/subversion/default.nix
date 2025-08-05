{
  bdbSupport ? true, # build support for Berkeley DB repositories
  httpServer ? false, # build Apache DAV module
  httpSupport ? true, # client must support http
  pythonBindings ? false,
  perlBindings ? false,
  javahlBindings ? false,
  saslSupport ? false,
  lib,
  stdenv,
  fetchurl,
  apr,
  aprutil,
  zlib,
  sqlite,
  openssl,
  lz4,
  utf8proc,
  autoconf,
  libtool,
  apacheHttpd ? null,
  expat,
  swig ? null,
  jdk ? null,
  python3 ? null,
  py3c ? null,
  perl ? null,
  sasl ? null,
  serf ? null,
}:

assert bdbSupport -> aprutil.bdbSupport;
assert httpServer -> apacheHttpd != null;
assert pythonBindings -> swig != null && python3 != null && py3c != null;
assert javahlBindings -> jdk != null && perl != null;

let
  common =
    {
      version,
      sha256,
      extraPatches ? [ ],
    }:
    stdenv.mkDerivation (
      rec {
        inherit version;
        pname = "subversion${lib.optionalString (!bdbSupport && perlBindings && pythonBindings) "-client"}";

        src = fetchurl {
          url = "mirror://apache/subversion/subversion-${version}.tar.bz2";
          inherit sha256;
        };

        # Can't do separate $lib and $bin, as libs reference bins
        outputs = [
          "out"
          "dev"
          "man"
        ];

        nativeBuildInputs = [
          autoconf
          libtool
          python3
        ];

        buildInputs = [
          zlib
          apr
          aprutil
          sqlite
          openssl
          lz4
          utf8proc
        ]
        ++ lib.optional httpSupport serf
        ++ lib.optionals pythonBindings [
          python3
          py3c
        ]
        ++ lib.optional perlBindings perl
        ++ lib.optional saslSupport sasl;

        patches = [ ./apr-1.patch ] ++ extraPatches;

        # remove vendored swig-3 files as these will shadow the swig provided
        # ones and result in compile errors
        postPatch = ''
          rm subversion/bindings/swig/proxy/{perlrun.swg,pyrun.swg,python.swg,rubydef.swg,rubyhead.swg,rubytracking.swg,runtime.swg,swigrun.swg}
        '';

        # We are hitting the following issue even with APR 1.6.x
        # -> https://issues.apache.org/jira/browse/SVN-4813
        # "-P" CPPFLAG is needed to build Python bindings and subversionClient
        CPPFLAGS = [ "-P" ];

        preConfigure = ''
          ./autogen.sh
        '';

        configureFlags = [
          (lib.withFeature bdbSupport "berkeley-db")
          (lib.withFeatureAs httpServer "apxs" "${apacheHttpd.dev}/bin/apxs")
          (lib.withFeatureAs (pythonBindings || perlBindings) "swig" swig)
          (lib.withFeatureAs saslSupport "sasl" sasl)
          (lib.withFeatureAs httpSupport "serf" serf)
          "--with-zlib=${zlib.dev}"
          "--with-sqlite=${sqlite.dev}"
          "--with-apr=${apr.dev}"
          "--with-apr-util=${aprutil.dev}"
        ]
        ++ lib.optionals javahlBindings [
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
              --replace "${openssl.dev}/lib" "${lib.getLib openssl}/lib"
          done
        '';

        inherit perlBindings pythonBindings;

        enableParallelBuilding = true;
        # Missing install dependencies:
        # libtool:   error: error: relink 'libsvn_ra_serf-1.la' with the above command before installing it
        # make: *** [build-outputs.mk:1316: install-serf-lib] Error 1
        enableParallelInstalling = false;

        nativeCheckInputs = [ python3 ];
        doCheck = false; # fails 10 out of ~2300 tests

        meta = with lib; {
          description = "Version control system intended to be a compelling replacement for CVS in the open source community";
          license = licenses.asl20;
          homepage = "https://subversion.apache.org/";
          mainProgram = "svn";
          maintainers = with maintainers; [ lovek323 ];
          platforms = platforms.linux ++ platforms.darwin;
        };

      }
      // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
        CXX = "clang++";
        CC = "clang";
        CPP = "clang -E";
        CXXCPP = "clang++ -E";
      }
    );

in
{
  subversion = common {
    version = "1.14.5";
    sha256 = "sha256-54op53Zri3s1RJfQj3GlVkGrxTZ1zhh1WEeBquNWRKE=";
  };
}
