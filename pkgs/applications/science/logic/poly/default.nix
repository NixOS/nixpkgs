{lib, stdenv, fetchFromGitHub, gmp, cmake, python3}:

stdenv.mkDerivation rec {
  pname = "libpoly";
<<<<<<< HEAD
  version = "0.1.13";
=======
  version = "0.1.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "libpoly";
    # they've pushed to the release branch, use explicit tag
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    sha256 = "sha256-7aFz+6XJOVEA/Fmi0ywd6rZdTW8sHq8MoHqXR0Hc2o4=";
=======
    sha256 = "sha256-vrYB6RQYShipZ0c0j1KcSTJR1h0rQKAAeJvODMar1GM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gmp python3 ];

  strictDeps = true;

  meta = with lib; {
    homepage = "https://github.com/SRI-CSL/libpoly";
    description = "C library for manipulating polynomials";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
