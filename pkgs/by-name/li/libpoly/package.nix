{
  lib,
  stdenv,
  fetchFromGitHub,
  gmp,
  cmake,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "libpoly";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "libpoly";
    # they've pushed to the release branch, use explicit tag
    rev = "refs/tags/v${version}";
    sha256 = "sha256-7aFz+6XJOVEA/Fmi0ywd6rZdTW8sHq8MoHqXR0Hc2o4=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    gmp
    python3
  ];

  strictDeps = true;

  meta = with lib; {
    homepage = "https://github.com/SRI-CSL/libpoly";
    description = "C library for manipulating polynomials";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
