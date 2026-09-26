{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spectra";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "yixuan";
    repo = "spectra";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-lfbOwnTP3GrN/1N/tyMXZrtEHIxAq3EjuHS8M+I87to=";
  };

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ eigen ];

  meta = {
    homepage = "https://spectralib.org/";
    description = "C++ library for large scale eigenvalue problems, built on top of Eigen";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ vonfry ];
    platforms = lib.platforms.unix;
  };
})
