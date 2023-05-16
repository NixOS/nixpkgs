{ lib
<<<<<<< HEAD
, fetchFromBitbucket
, buildPythonApplication
, pyqt5
, matplotlib
, numpy
, cycler
, python-dateutil
, kiwisolver
, six
, setuptools
, dill
, rtree
, pyopengl
, vispy
, ortools
, svg-path
, simplejson
, shapely
, freetype-py
, fonttools
, rasterio
, lxml
, ezdxf
, qrcode
, reportlab
, svglib
, gdal
, pyserial
, python3
}:

buildPythonApplication rec {
  pname = "flatcam";
  version = "unstable-2022-02-02";
=======
, stdenv
, python3
, fetchFromBitbucket
, fetchpatch
, substituteAll
, geos
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      shapely = super.shapely.overridePythonAttrs (old: rec {
        version = "1.8.4";
        src = self.fetchPypi {
          pname = "Shapely";
          inherit version;
          hash = "sha256-oZXlHKr6IYKR8suqP+9p/TNTyT7EtlsqRyLEz0DDGYw=";
        };
        # Environment variable used in shapely/_buildcfg.py
        GEOS_LIBRARY_PATH = "${geos}/lib/libgeos_c${stdenv.hostPlatform.extensions.sharedLibrary}";
        patches = [
          # Patch to search form GOES .so/.dylib files in a Nix-aware way
          (substituteAll {
            src = ./shapely-library-paths.patch;
            libgeos_c = GEOS_LIBRARY_PATH;
            libc = lib.optionalString (!stdenv.isDarwin) "${stdenv.cc.libc}/lib/libc${stdenv.hostPlatform.extensions.sharedLibrary}.6";
          })
        ];
      });
    };
  };
in python.pkgs.buildPythonApplication rec {
  pname = "flatcam";
  version = "8.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromBitbucket {
    owner = "jpcgt";
    repo = pname;
<<<<<<< HEAD
    rev = "ebf5cb9e3094362c4b0774a54cf119559c02211d"; # beta branch as of 2022-02-02
    hash = "sha256-QKkBPEM+HVYmSZ83b4JRmOmCMp7C3EUqbJKPqUXMiKE=";
  };

  format = "other";

  dontBuild = true;

  propagatedBuildInputs = [
    pyqt5
    matplotlib
    numpy
    cycler
    python-dateutil
    kiwisolver
    six
    setuptools
    dill
    rtree
    pyopengl
    vispy
    ortools
    svg-path
    simplejson
    shapely
    freetype-py
    fonttools
    rasterio
    lxml
    ezdxf
    qrcode
    reportlab
    svglib
    gdal
    pyserial
  ];

  preInstall = ''
    patchShebangs .

    sed -i "s|/usr/local/bin|$out/bin|" Makefile

    mkdir -p $out/share/{flatcam,applications}
    mkdir -p $out/bin
  '';

  installFlags = [
    "USER_ID=0"
    "LOCAL_PATH=/build/source/."
    "INSTALL_PATH=${placeholder "out"}/share/flatcam"
    "APPS_PATH=${placeholder "out"}/share/applications"
  ];

  postInstall = ''
    sed -i "s|python3|${python3.withPackages (_: propagatedBuildInputs)}/bin/python3|" $out/bin/flatcam-beta
    mv $out/bin/flatcam{-beta,}
=======
    rev = "533afd6a1772857cb633c011b5e0a15b60b1e92e"; # 8.5 with Red Hat packaging.
    sha256 = "199kiiml18k34z1zhk2hbhibphmnv0kb11kxiajq52alps0mjb3m";
  };

  propagatedBuildInputs = with python.pkgs; [
    matplotlib
    numpy
    packaging
    pyqt4
    rtree
    scipy
    setuptools
    shapely
    simplejson
    six
    svg-path
  ];

  packaging_fix_pull_request_patch = fetchpatch {
    name = "packaging_fix_pull_request.patch";
    url = "https://bitbucket.org/trepetti/flatcam/commits/5591ed889d1f48a5190fe237b562cb932cb5876c/raw";
    sha256 = "19rhjdrf1n1q29cgpcry6pl2kl90zq0d613hhkwdir9bhq5bkknp";
  };

  patches = [
    packaging_fix_pull_request_patch
    ./release.patch
  ];

  # Only non-GUI tests can be run deterministically in the Nix build environment.
  checkPhase = ''
    python -m unittest tests.test_excellon
    python -m unittest tests.test_gerber_buffer
    python -m unittest tests.test_paint
    python -m unittest tests.test_pathconnect
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "2-D post processing for PCB fabrication on CNC routers";
    homepage = "https://bitbucket.org/jpcgt/flatcam";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
