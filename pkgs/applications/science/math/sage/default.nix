{ pkgs
, withDoc ? false
}:

# Here sage and its dependencies are put together. Some dependencies may be pinned
# as a last resort. Patching sage for compatibility with newer dependency versions
# is always preferred, see `sage-src.nix` for that.

let
  inherit (pkgs) fetchurl symlinkJoin callPackage nodePackages;

  # https://trac.sagemath.org/ticket/15980 for tracking of python3 support
  python = pkgs.python2.override {
    packageOverrides = self: super: {
      # python packages that appear unmaintained and were not accepted into the nixpkgs
      # tree because of that. These packages are only dependencies of the more-or-less
      # deprecated sagenb. However sagenb is still a default dependency and the doctests
      # depend on it.
      # See https://github.com/NixOS/nixpkgs/pull/38787 for a discussion.
      # The dependency on the sage notebook (and therefore these packages) will be
      # removed in the future:
      # https://trac.sagemath.org/ticket/25837
      flask-oldsessions = self.callPackage ./flask-oldsessions.nix {};
      flask-openid = self.callPackage ./flask-openid.nix {};
      python-openid = self.callPackage ./python-openid.nix {};
      sagenb = self.callPackage ./sagenb.nix {
        mathjax = nodePackages.mathjax;
      };

      # Package with a cyclic dependency with sage
      pybrial = self.callPackage ./pybrial.nix {};

      # `sagelib`, i.e. all of sage except some wrappers and runtime dependencies
      sagelib = self.callPackage ./sagelib.nix {
        inherit flint ecl arb;
        inherit sage-src pynac singular;
        linbox = pkgs.linbox.override { withSage = true; };
      };
    };
  };

  jupyter-kernel-definition = {
    displayName = "SageMath ${sage-src.version}";
    argv = [
      "${sage-with-env}/bin/sage" # FIXME which sage
      "--python"
      "-m"
      "sage.repl.ipython_kernel"
      "-f"
      "{connection_file}"
    ];
    language = "sagemath";
    # just one 16x16 logo is available
    logo32 = "${sage-src}/doc/common/themes/sage/static/sageicon.png";
    logo64 = "${sage-src}/doc/common/themes/sage/static/sageicon.png";
  };

  # A bash script setting various environment variables to tell sage where
  # the files its looking fore are located. Also see `sage-env`.
  env-locations = callPackage ./env-locations.nix {
    inherit pari_data ecl;
    inherit singular;
    cysignals = python.pkgs.cysignals;
    three = nodePackages.three;
    mathjax = nodePackages.mathjax;
  };

  # The shell file that gets sourced on every sage start. Will also source
  # the env-locations file.
  sage-env = callPackage ./sage-env.nix {
    sagelib = python.pkgs.sagelib;
    inherit env-locations;
    inherit python ecl singular palp flint pynac pythonEnv;
    pkg-config = pkgs.pkgconfig; # not to confuse with pythonPackages.pkgconfig
  };

  # The documentation for sage, building it takes a lot of ram.
  sagedoc = callPackage ./sagedoc.nix {
    inherit sage-with-env;
    inherit python;
  };

  # sagelib with added wrappers and a dependency on sage-tests to make sure thet tests were run.
  sage-with-env = callPackage ./sage-with-env.nix {
    inherit pythonEnv;
    inherit sage-env;
    inherit pynac singular;
    pkg-config = pkgs.pkgconfig; # not to confuse with pythonPackages.pkgconfig
    three = nodePackages.three;
  };

  # Doesn't actually build anything, just runs sages testsuite. This is a
  # separate derivation to make it possible to re-run the tests without
  # rebuilding sagelib (which takes ~30 minutes).
  # Running the tests should take something in the order of 1h.
  sage-tests = callPackage ./sage-tests.nix {
    inherit sage-with-env;
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
    tkinter # optional, as a matplotlib backend (use with `%matplotlib tk`)
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

  arb = pkgs.arb.override { inherit flint; };

  singular = pkgs.singular.override { inherit flint; };

  # *not* to confuse with the python package "pynac"
  pynac = pkgs.pynac.override { inherit singular flint; };

  # With openblas (64 bit), the tests fail the same way as when sage is build with
  # openblas instead of openblasCompat. Apparently other packages somehow use flints
  # blas when it is available. Alternative would be to override flint to use
  # openblasCompat.
  flint = pkgs.flint.override { withBlas = false; };

  # Multiple palp dimensions need to be available and sage expects them all to be
  # in the same folder.
  palp = symlinkJoin {
    name = "palp-${pkgs.palp.version}";
    paths = [
      (pkgs.palp.override { dimensions = 4; doSymlink = false; })
      (pkgs.palp.override { dimensions = 5; doSymlink = false; })
      (pkgs.palp.override { dimensions = 6; doSymlink = true; })
      (pkgs.palp.override { dimensions = 11; doSymlink = false; })
    ];
  };

  # Sage expects those in the same directory.
  pari_data = symlinkJoin {
    name = "pari_data";
    paths = with pkgs; [
      pari-galdata
      pari-seadata-small
    ];
  };

  # https://trac.sagemath.org/ticket/22191
  ecl = pkgs.ecl_16_1_2;
in
# A wrapper around sage that makes sure sage finds its docs (if they were build).
callPackage ./sage.nix {
  inherit sage-tests sage-with-env sagedoc jupyter-kernel-definition;
  inherit withDoc;
}
