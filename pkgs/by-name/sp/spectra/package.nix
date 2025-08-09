{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
}:

stdenv.mkDerivation rec {
  pname = "spectra";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "yixuan";
    repo = "spectra";
    rev = "v${version}";
    sha256 = "sha256-lfbOwnTP3GrN/1N/tyMXZrtEHIxAq3EjuHS8M+I87to=";
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
