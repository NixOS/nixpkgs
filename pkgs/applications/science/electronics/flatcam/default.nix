{ lib
, python3Packages
, fetchFromBitbucket
, fetchpatch
}:

python3Packages.buildPythonApplication rec {
  pname = "flatcam";
  version = "8.5";

  src = fetchFromBitbucket {
    owner = "jpcgt";
    repo = pname;
    rev = "533afd6a1772857cb633c011b5e0a15b60b1e92e"; # 8.5 with Red Hat packaging.
    sha256 = "199kiiml18k34z1zhk2hbhibphmnv0kb11kxiajq52alps0mjb3m";
  };

  propagatedBuildInputs = with python3Packages; [
    matplotlib
    numpy
    packaging
    pyqt4
    Rtree
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
  '';

  meta = with lib; {
    description = "2-D post processing for PCB fabrication on CNC routers";
    homepage = "https://bitbucket.org/jpcgt/flatcam";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
