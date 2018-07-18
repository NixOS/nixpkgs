{ nixpkgs
, withDoc ? false
}:

let
  inherit (sagepkgs) fetchpatch fetchurl symlinkJoin fetchFromGitHub callPackage nodePackages_8_x;

  sagepkgs = import nixpkgs.path {
    overlays = [
      (self: super: {
        # https://trac.sagemath.org/ticket/15980 for tracking of python3 support
        python2 = super.python2.override {
          packageOverrides = pSelf: pSuper: { # distinguish from nixpkgs self/super
            # python packages that appear unmaintained and were not accepted into the nixpkgs
            # tree because of that. These packages are only dependencies of the more-or-less
            # deprecated sagenb. However sagenb is still a default dependency and the doctests
            # depend on it.
            # See https://github.com/NixOS/nixpkgs/pull/38787 for a discussion.
            flask-oldsessions = pSelf.callPackage ./flask-oldsessions.nix {};
            flask-openid = pSelf.callPackage ./flask-openid.nix {};
            python-openid = pSelf.callPackage ./python-openid.nix {};

            pybrial = pSelf.callPackage ./pybrial.nix {};

            sagelib = pSelf.callPackage ./sagelib.nix {
              pynac = self.pynac;
              linbox = self.linbox.override { withSage = true; };
            };

            sagenb = pSelf.callPackage ./sagenb.nix {
              mathjax = nodePackages_8_x.mathjax;
            };

            sagedoc = pSelf.callPackage ./sagedoc.nix { };

            env-locations = pSelf.callPackage ./env-locations.nix {
              # Sage expects those in the same directory.
              pari_data = symlinkJoin {
                name = "pari_data";
                paths = with self; [
                  pari-galdata
                  pari-seadata-small
                ];
              };
              three = nodePackages_8_x.three;
              mathjax = nodePackages_8_x.mathjax;
            };

            sagePython2Env = let
              pythonRuntimeDeps = with self.python2.pkgs; [
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
            in
              self.python2.buildEnv.override {
              extraLibs = pythonRuntimeDeps;
              ignoreCollisions = true;
            } // { extraLibs = pythonRuntimeDeps; }; # make the libs accessible

            sage-env = pSelf.callPackage ./sage-env.nix {
              pynac = self.pynac;
              pkg-config = self.pkgconfig; # not to confuse with pythonPackages.pkgconfig
            };

            sage-with-env = pSelf.callPackage ./sage-with-env.nix {
              pynac = self.pynac;
              pkg-config = self.pkgconfig; # not to confuse with pythonPackages.pkgconfig
              three = nodePackages_8_x.three;
            };

            sage = pSelf.callPackage ./sage.nix { };

            sage-wrapper = pSelf.callPackage ./sage-wrapper.nix {
              inherit withDoc;
            };
          };
        };

        # update causes issues
        # https://groups.google.com/forum/#!topic/sage-packaging/cS3v05Q0zso
        # https://trac.sagemath.org/ticket/24735
        singular = super.singular.overrideAttrs (oldAttrs: {
          name = "singular-4.1.0p3";
          src = fetchurl {
            url = "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-1-0/singular-4.1.0p3.tar.gz";
            sha256 = "105zs3zk46b1cps403ap9423rl48824ap5gyrdgmg8fma34680a4";
          };
        });

        # sage currently uses an unreleased version of pari
        pari = (super.pari.override { withThread = false; }).overrideAttrs (attrs: rec {
          version = "2.10-1280-g88fb5b3"; # on update remove pari-stackwarn patch from `sage-src.nix`
          src = fetchurl {
            url = "mirror://sageupstream/pari/pari-${version}.tar.gz";
            sha256 = "19gbsm8jqq3hraanbmsvzkbh88iwlqbckzbnga3y76r7k42akn7m";
          };
        });

        # With openblas (64 bit), the tests fail the same way as when sage is build with
        # openblas instead of openblasCompat. Apparently other packages somehow use flints
        # blas when it is available. Alternative would be to override flint to use
        # openblasCompat.
        flint = super.flint.override { withBlas = false; };

        # https://trac.sagemath.org/ticket/24824
        glpk = super.glpk.overrideAttrs (attrs: rec {
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

        # https://trac.sagemath.org/ticket/22191
        ecl = super.ecl_16_1_2;

        # https://trac.sagemath.org/ticket/25674
        R = super.R.overrideAttrs (attrs: rec {
          name = "R-3.4.4";
          src = fetchurl {
            url = "http://cran.r-project.org/src/base/R-3/${name}.tar.gz";
            sha256 = "0dq3jsnwsb5j3fhl0wi3p5ycv8avf8s5j1y4ap3d2mkjmcppvsdk";
          };
        });

        openblas-blas-pc = callPackage ./openblas-pc.nix { name = "blas"; };
        openblas-cblas-pc = callPackage ./openblas-pc.nix { name = "cblas"; };
        openblas-lapack-pc = callPackage ./openblas-pc.nix { name = "lapack"; };

        sage-src = callPackage ./sage-src.nix {};

        # Multiple palp dimensions need to be available and sage expects them all to be
        # in the same folder.
        palp = symlinkJoin {
          name = "palp-${super.palp.version}";
          paths = [
            (super.palp.override { dimensions = 4; doSymlink = false; })
            (super.palp.override { dimensions = 5; doSymlink = false; })
            (super.palp.override { dimensions = 6; doSymlink = true; })
            (super.palp.override { dimensions = 11; doSymlink = false; })
          ];
        };
      })
    ];
  };
in
  sagepkgs.python.pkgs.sage-wrapper // {
    doc = sagepkgs.python.pkgs.sagedoc;
    lib = sagepkgs.python.pkgs.sagelib;
    overlay = sagepkgs;
  }
