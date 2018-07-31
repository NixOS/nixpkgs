{ nixpkgs
, withDoc ? false
}:

let
  inherit (nixpkgs) fetchpatch fetchurl symlinkJoin callPackage nodePackages_8_x;

  # https://trac.sagemath.org/ticket/15980 for tracking of python3 support
  python = nixpkgs.python2.override {
    packageOverrides = self: super: {
      cypari2 = super.cypari2.override { inherit pari; };

      cysignals = super.cysignals.override { inherit pari; };

      # python packages that appear unmaintained and were not accepted into the nixpkgs
      # tree because of that. These packages are only dependencies of the more-or-less
      # deprecated sagenb. However sagenb is still a default dependency and the doctests
      # depend on it.
      # See https://github.com/NixOS/nixpkgs/pull/38787 for a discussion.
      flask-oldsessions = self.callPackage ./flask-oldsessions.nix {};
      flask-openid = self.callPackage ./flask-openid.nix {};
      python-openid = self.callPackage ./python-openid.nix {};

      pybrial = self.callPackage ./pybrial.nix {};

      sagelib = self.callPackage ./sagelib.nix {
        inherit flint ecl pari eclib ntl arb;
        inherit sage-src openblas-blas-pc openblas-cblas-pc openblas-lapack-pc pynac singular;
        linbox = nixpkgs.linbox.override { withSage = true; };
      };

      sagenb = self.callPackage ./sagenb.nix {
        mathjax = nodePackages_8_x.mathjax;
      };

      sagedoc = self.callPackage ./sagedoc.nix {
        inherit sage-src;
      };

      env-locations = self.callPackage ./env-locations.nix {
        inherit pari_data ecl pari;
        inherit singular;
        three = nodePackages_8_x.three;
        mathjax = nodePackages_8_x.mathjax;
      };

      sage-env = self.callPackage ./sage-env.nix {
        inherit sage-src python rWrapper openblas-cblas-pc ecl singular eclib pari palp flint pynac pythonEnv giac ntl;
        pkg-config = nixpkgs.pkgconfig; # not to confuse with pythonPackages.pkgconfig
      };

      sage-with-env = self.callPackage ./sage-with-env.nix {
        inherit pari eclib pythonEnv ntl;
        inherit sage-src openblas-blas-pc openblas-cblas-pc openblas-lapack-pc pynac singular giac;
        pkg-config = nixpkgs.pkgconfig; # not to confuse with pythonPackages.pkgconfig
        three = nodePackages_8_x.three;
      };

      sage = self.callPackage ./sage.nix { };

      sage-wrapper = self.callPackage ./sage-wrapper.nix {
        inherit sage-src withDoc;
      };
    };
  };

  openblas-blas-pc = callPackage ./openblas-pc.nix { name = "blas"; };
  openblas-cblas-pc = callPackage ./openblas-pc.nix { name = "cblas"; };
  openblas-lapack-pc = callPackage ./openblas-pc.nix { name = "lapack"; };

  sage-src = callPackage ./sage-src.nix {};

  pythonRuntimeDeps = with python.pkgs; [
    sagelib
    pybrial
    sagenb
    cvxopt
    networkx
    service-identity
    psutil
    sympy
    fpylll
    matplotlib
    scipy
    ipywidgets
    rpy2
    sphinx
    typing
    pillow
  ];

  pythonEnv = python.buildEnv.override {
    extraLibs = pythonRuntimeDeps;
    ignoreCollisions = true;
  } // { extraLibs = pythonRuntimeDeps; }; # make the libs accessible

  # needs to be rWrapper, standard "R" doesn't include default packages
  rWrapper = nixpkgs.rWrapper.override {
    # https://trac.sagemath.org/ticket/25674
    R = nixpkgs.R.overrideAttrs (attrs: rec {
      name = "R-3.4.4";
      src = fetchurl {
        url = "http://cran.r-project.org/src/base/R-3/${name}.tar.gz";
        sha256 = "0dq3jsnwsb5j3fhl0wi3p5ycv8avf8s5j1y4ap3d2mkjmcppvsdk";
      };
    });
  };

  # https://trac.sagemath.org/ticket/25532
  ntl = nixpkgs.ntl.overrideAttrs (oldAttrs: rec {
    name = "ntl-10.5.0";
    sourceRoot = "${name}/src";
    src = fetchurl {
      url = "http://www.shoup.net/ntl/${name}.tar.gz";
      sha256 = "1lmldaldgfr2b2a6585m3np5ds8bq1bis2s1ajycjm49vp4kc2xr";
    };
  });

  giac = nixpkgs.giac.override { inherit ntl; };
  arb = nixpkgs.arb.override { inherit flint; };

  # update causes issues
  # https://groups.google.com/forum/#!topic/sage-packaging/cS3v05Q0zso
  # https://trac.sagemath.org/ticket/24735
  singular = (nixpkgs.singular.override { inherit ntl flint; }).overrideAttrs (oldAttrs: {
    name = "singular-4.1.0p3";
    src = fetchurl {
      url = "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-1-0/singular-4.1.0p3.tar.gz";
      sha256 = "105zs3zk46b1cps403ap9423rl48824ap5gyrdgmg8fma34680a4";
    };
  });

  # *not* to confuse with the python package "pynac"
  # https://trac.sagemath.org/ticket/24838 (depends on arb update)
  pynac = nixpkgs.pynac.override { inherit singular flint; };

  eclib = nixpkgs.eclib.override { inherit pari ntl; };

  # With openblas (64 bit), the tests fail the same way as when sage is build with
  # openblas instead of openblasCompat. Apparently other packages somehow use flints
  # blas when it is available. Alternative would be to override flint to use
  # openblasCompat.
  flint = nixpkgs.flint.override { withBlas = false; inherit ntl; };

  # Multiple palp dimensions need to be available and sage expects them all to be
  # in the same folder.
  palp = symlinkJoin {
    name = "palp-${nixpkgs.palp.version}";
    paths = [
      (nixpkgs.palp.override { dimensions = 4; doSymlink = false; })
      (nixpkgs.palp.override { dimensions = 5; doSymlink = false; })
      (nixpkgs.palp.override { dimensions = 6; doSymlink = true; })
      (nixpkgs.palp.override { dimensions = 11; doSymlink = false; })
    ];
  };

  # Sage expects those in the same directory.
  pari_data = symlinkJoin {
    name = "pari_data";
    paths = with nixpkgs; [
      pari-galdata
      pari-seadata-small
    ];
  };

  # https://trac.sagemath.org/ticket/22191
  ecl = nixpkgs.ecl_16_1_2;

  # sage currently uses an unreleased version of pari
  pari = (nixpkgs.pari.override { withThread = false; }).overrideAttrs (attrs: rec {
    version = "2.10-1280-g88fb5b3"; # on update remove pari-stackwarn patch from `sage-src.nix`
    src = fetchurl {
      url = "mirror://sageupstream/pari/pari-${version}.tar.gz";
      sha256 = "19gbsm8jqq3hraanbmsvzkbh88iwlqbckzbnga3y76r7k42akn7m";
    };
  });
in
  python.pkgs.sage-wrapper // {
    doc = python.pkgs.sagedoc;
    lib = python.pkgs.sagelib;
  }
