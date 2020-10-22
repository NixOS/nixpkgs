{ pkgs
, withDoc ? false
}:

# Here sage and its dependencies are put together. Some dependencies may be pinned
# as a last resort. Patching sage for compatibility with newer dependency versions
# is always preferred, see `sage-src.nix` for that.

let
  inherit (pkgs) symlinkJoin callPackage nodePackages;

  python = pkgs.python3.override {
    packageOverrides = self: super: {
      # `sagelib`, i.e. all of sage except some wrappers and runtime dependencies
      sagelib = self.callPackage ./sagelib.nix {
        inherit flint arb;
        inherit sage-src env-locations pynac singular;
        linbox = pkgs.linbox.override { withSage = true; };
        pkg-config = pkgs.pkgconfig; # not to confuse with pythonPackages.pkgconfig
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
    inherit pari_data;
    inherit singular maxima-ecl;
    cysignals = python.pkgs.cysignals;
    three = nodePackages.three;
    mathjax = nodePackages.mathjax;
  };

  # The shell file that gets sourced on every sage start. Will also source
  # the env-locations file.
  sage-env = callPackage ./sage-env.nix {
    sagelib = python.pkgs.sagelib;
    inherit env-locations;
    inherit python singular palp flint pynac pythonEnv maxima-ecl;
    pkg-config = pkgs.pkgconfig; # not to confuse with pythonPackages.pkgconfig
  };

  # The documentation for sage, building it takes a lot of ram.
  sagedoc = callPackage ./sagedoc.nix {
    inherit sage-with-env;
    inherit python maxima-ecl;
  };

  # sagelib with added wrappers and a dependency on sage-tests to make sure thet tests were run.
  sage-with-env = callPackage ./sage-with-env.nix {
    inherit pythonEnv;
    inherit sage-env;
    inherit pynac singular maxima-ecl;
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

  maxima-ecl = pkgs.maxima-ecl;

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
in
# A wrapper around sage that makes sure sage finds its docs (if they were build).
callPackage ./sage.nix {
  inherit sage-tests sage-with-env sagedoc jupyter-kernel-definition;
  inherit withDoc;
}
