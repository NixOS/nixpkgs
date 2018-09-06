{ nixpkgs
, withDoc ? false
}:

let
  inherit (nixpkgs) fetchpatch fetchurl symlinkJoin callPackage nodePackages_8_x;

  # https://trac.sagemath.org/ticket/15980 for tracking of python3 support
  python = nixpkgs.python2.override {
    packageOverrides = self: super: {
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
        inherit flint ecl arb;
        inherit sage-src pynac singular;
        linbox = nixpkgs.linbox.override { withSage = true; };
      };

      sagenb = self.callPackage ./sagenb.nix {
        mathjax = nodePackages_8_x.mathjax;
      };

      sagedoc = self.callPackage ./sagedoc.nix {
        inherit sage-src;
      };

      env-locations = self.callPackage ./env-locations.nix {
        inherit pari_data ecl;
        inherit singular;
        three = nodePackages_8_x.three;
        mathjax = nodePackages_8_x.mathjax;
      };

      sage-env = self.callPackage ./sage-env.nix {
        inherit sage-src python rWrapper ecl singular palp flint pynac pythonEnv;
        pkg-config = nixpkgs.pkgconfig; # not to confuse with pythonPackages.pkgconfig
      };

      sage-with-env = self.callPackage ./sage-with-env.nix {
        inherit pythonEnv;
        inherit sage-src pynac singular;
        pkg-config = nixpkgs.pkgconfig; # not to confuse with pythonPackages.pkgconfig
        three = nodePackages_8_x.three;
      };

      sage = self.callPackage ./sage.nix { };

      sage-wrapper = self.callPackage ./sage-wrapper.nix {
        inherit sage-src withDoc;
      };
    };
  };

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

  arb = nixpkgs.arb.override { inherit flint; };

  singular = nixpkgs.singular.override { inherit flint; };

  # *not* to confuse with the python package "pynac"
  pynac = nixpkgs.pynac.override { inherit singular flint; };

  # With openblas (64 bit), the tests fail the same way as when sage is build with
  # openblas instead of openblasCompat. Apparently other packages somehow use flints
  # blas when it is available. Alternative would be to override flint to use
  # openblasCompat.
  flint = nixpkgs.flint.override { withBlas = false; };

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
in
  python.pkgs.sage-wrapper // {
    doc = python.pkgs.sagedoc;
    lib = python.pkgs.sagelib;
  }
