{ nixpkgs
, withDoc ? false
}:

let
  inherit (nixpkgs) fetchpatch fetchurl symlinkJoin fetchFromGitHub callPackage nodePackages_8_x;

  # https://trac.sagemath.org/ticket/15980 for tracking of python3 support
  python = nixpkgs.python2.override {
    packageOverrides = self: super: {
      cypari2 = super.cypari2.override { inherit pari; };

      cysignals = super.cysignals.override { inherit pari; };

      cvxopt = super.cvxopt.override { inherit glpk; };

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
        inherit flint ecl pari glpk eclib;
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
        inherit sage-src python rWrapper openblas-cblas-pc glpk ecl singular eclib pari palp flint pynac pythonEnv;
        pkg-config = nixpkgs.pkgconfig; # not to confuse with pythonPackages.pkgconfig
      };

      sage-with-env = self.callPackage ./sage-with-env.nix {
        inherit pari eclib pythonEnv;
        inherit sage-src openblas-blas-pc openblas-cblas-pc openblas-lapack-pc pynac singular;
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

  # update causes issues
  # https://groups.google.com/forum/#!topic/sage-packaging/cS3v05Q0zso
  # https://trac.sagemath.org/ticket/24735
  singular = nixpkgs.singular.overrideAttrs (oldAttrs: {
    name = "singular-4.1.0p3";
    src = fetchurl {
      url = "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-1-0/singular-4.1.0p3.tar.gz";
      sha256 = "105zs3zk46b1cps403ap9423rl48824ap5gyrdgmg8fma34680a4";
    };
  });

  # *not* to confuse with the python package "pynac"
  # https://trac.sagemath.org/ticket/24838 (depends on arb update)
  pynac = nixpkgs.pynac.override { inherit singular; };

  eclib = nixpkgs.eclib.override { inherit pari; };

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

  # sage currently uses an unreleased version of pari
  pari = (nixpkgs.pari.override { withThread = false; }).overrideAttrs (attrs: rec {
    version = "2.10-1280-g88fb5b3"; # on update remove pari-stackwarn patch from `sage-src.nix`
    src = fetchurl {
      url = "mirror://sageupstream/pari/pari-${version}.tar.gz";
      sha256 = "19gbsm8jqq3hraanbmsvzkbh88iwlqbckzbnga3y76r7k42akn7m";
    };
  });

  # https://trac.sagemath.org/ticket/24824
  glpk = nixpkgs.glpk.overrideAttrs (attrs: rec {
    version = "4.63";
    name = "glpk-${version}";
    src = fetchurl {
      url = "mirror://gnu/glpk/${name}.tar.gz";
      sha256 = "1xp7nclmp8inp20968bvvfcwmz3mz03sbm0v3yjz8aqwlpqjfkci";
    };
    patches = (attrs.patches or []) ++ [
      # Alternatively patch sage with debians
      # https://sources.debian.org/data/main/s/sagemath/8.1-7/debian/patches/t-version-glpk-4.60-extra-hack-fixes.patch
      # The header of that debian patch contains a good description of the issue. The gist of it:
      # > If GLPK in Sage causes one error, and this is caught by Sage and recovered from, then
      # > later (because upstream GLPK does not clear the "error" flag) Sage will append
      # > all subsequent terminal output of GLPK into the error_message string but not
      # > actually forward it to the user's terminal. This breaks some doctests.
      (fetchpatch {
        name = "error_recovery.patch";
        url = "https://git.sagemath.org/sage.git/plain/build/pkgs/glpk/patches/error_recovery.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
        sha256 = "0z99z9gd31apb6x5n5n26411qzx0ma3s6dnznc4x61x86bhq31qf";
      })

      # Allow setting a exact verbosity level (OFF|ERR|ON|ALL|DBG)
      (fetchpatch {
        name = "exact_verbosity.patch";
        url = "https://git.sagemath.org/sage.git/plain/build/pkgs/glpk/patches/glp_exact_verbosity.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
        sha256 = "15gm5i2alqla3m463i1qq6jx6c0ns6lip7njvbhp37pgxg4s9hx8";
      })
    ];
  });
in
  python.pkgs.sage-wrapper // {
    doc = python.pkgs.sagedoc;
    lib = python.pkgs.sagelib;
  }
