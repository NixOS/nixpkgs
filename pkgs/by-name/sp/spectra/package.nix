{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
}:

stdenv.mkDerivation rec {
  pname = "spectra";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "yixuan";
    repo = "spectra";
    rev = "v${version}";
    sha256 = "sha256-ut6nEOpzIoFy+IUWQy9x2pJ4+sA0d/Dt8WaNq5AFCFg=";
  };

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ eigen ];

  meta = with lib; {
    homepage = "https://spectralib.org/";
    description = "C++ library for large scale eigenvalue problems, built on top of Eigen";
    license = licenses.mpl20;
    maintainers = with maintainers; [ vonfry ];
    platforms = platforms.unix;
  };
}
