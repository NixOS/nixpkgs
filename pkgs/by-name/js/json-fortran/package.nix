{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "json-fortran";
  version = "9.0.5";

  src = fetchFromGitHub {
    owner = "jacobwilliams";
    repo = "json-fortran";
    rev = version;
    hash = "sha256-4IyysBcGKJKET8A5Bbbd5WJtlNh/7EdHuXsR6B/VDh0=";
  };

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  cmakeFlags = [
    "-DUSE_GNU_INSTALL_CONVENTION=ON"
  ];

  # Due to some misconfiguration in CMake the Fortran modules end up in $out/$out.
  # Move them back to the desired location.
  postInstall = ''
    mv $out/$out/include $out/.
    rm -r $out/nix
  '';

<<<<<<< HEAD
  meta = {
    description = "Modern Fortran JSON API";
    homepage = "https://github.com/jacobwilliams/json-fortran";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
=======
  meta = with lib; {
    description = "Modern Fortran JSON API";
    homepage = "https://github.com/jacobwilliams/json-fortran";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
