{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "json-fortran";
  version = "9.2.0";

  src = fetchFromGitHub {
    owner = "jacobwilliams";
    repo = "json-fortran";
    rev = finalAttrs.version;
    hash = "sha256-DjNBB1qYXZcUSvjcWqunFeI275F3YojRDCRf61pIkYs=";
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

  meta = {
    description = "Modern Fortran JSON API";
    homepage = "https://github.com/jacobwilliams/json-fortran";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
