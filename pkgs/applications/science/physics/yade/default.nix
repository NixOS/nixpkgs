{ stdenv, fetchurl, fetchFromGitHub, pkgconfig, cmake, makeWrapper, python27Packages,
boost, cgal, loki, pythonFull, eigen3_3, bzip2, zlib, openblas, vtk, gmp, gts, metis,
mpfr, suitesparse, glib, pcre } :

let

    pythonPackages = python27Packages;

    minieigen = pythonPackages.buildPythonPackage rec {
      name = "minieigen";

      src = fetchFromGitHub {
        owner = "eudoxos";
        repo = "minieigen";
        rev = "7bd0a2e823333477a2172b428a3801d9cae0800f";
        sha256 = "1jksrbbcxshxx8iqpxkc1y0v091hwji9xvz9w963gjpan4jf61wj";
        };

      buildInputs = [ unzip pythonPackages.boost boost eigen3_3 ];

      postPatch = ''
        sed -i "s/^.*libraries=libraries.//g" setup.py 
      '';

      preConfigure = ''
        export LDFLAGS="-L${eigen3_3}/lib -l boost_python"
        export CFLAGS="-I${eigen3_3}/include/eigen3"
      '';

    };

in 


  stdenv.mkDerivation rec {

    name = "yade-${version}";
    version = "2017.01a";

    meta = {
      description = "An extensible open-source framework for discrete numerical models, focused on Discrete Element Method";
      license     = stdenv.lib.licenses.gpl2;
      homepage    = https://www.yade-dem.org/;
      platforms   = stdenv.lib.platforms.unix;
      maintainers = with stdenv.lib.maintainers; [ remche ];
    };

    nativeBuildInputs = [
      pkgconfig
      cmake
      makeWrapper
      python2Packages.wrapPython
    ];

    buildInputs = [
      boost
      cgal
      loki
      python27
      python27.tkinter
      python27Packages.numpy
      eigen3_3
      bzip2
      zlib
      openblas
      vtk
      gmp
      gts
      metis
      mpfr
      suitesparse
      glib
      pcre
      minieigen
    ];

    pythonPath = with pythonPackages; [
      pygments
      pexpect
      decorator
      numpy
      ipython
      ipython_genutils
      traitlets
      enum
      six
      boost
      minieigen
      pillow
      matplotlib
    ];

    src = fetchFromGitHub {
      owner = "yade";
      repo = "trunk";
      rev = "d75e86de325527b28a1a3b7e79d4572319dc2bc4";
      sha256 = "0njipn8gfprvi6qr31qdrzdzm7qww12qysk1r4yjz5341jar9i72";
      };

    patches = [ ./cmake.patch ];

    postInstall = ''
      wrapPythonPrograms
    '';

    enableParallelBuilding = true;

    cmakeFlags = [ "-DCMAKE_INSTALL_PREFIX=$out -DENABLE_GUI=OFF -DSUFFIX=-${version}" ];

  }



