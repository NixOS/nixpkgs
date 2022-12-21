{ lib
, pkgs
, stdenv
, fetchFromGitLab
, cmake
, extra-cmake-modules
, glib
}:

stdenv.mkDerivation rec {
  pname = "lomiri-api";
  version = "unstable-2022-10-27";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "ubports";
    repo = "development/core/lomiri-api";
    rev = "b906e5245fe1f4ac6e83e3ff04bd27d68e9d1603";
    sha256 = "sha256-EVf1fhKB38F/0UyxTeiVWLR7NcX7JWLG7efJD6Zs1y8=";
  };

  postPatch = ''
    # Fix broken path found in pc file
    sed -i "s|/@CMAKE_INSTALL_LIBDIR@|@CMAKE_INSTALL_LIBDIR@|" data/liblomiri-api.pc.in
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    glib
  ];

  cmakeFlags = [ "-DNO_TESTS=ON" ];

  meta = with lib; {
    description = "Lomiri API library";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-api";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
  };

}
