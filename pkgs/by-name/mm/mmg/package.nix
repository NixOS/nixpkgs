{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  cmake,
  perl,
}:
stdenv.mkDerivation {
  pname = "mmg";
  version = "5.7.3-unstable-2024-05-31";

  src = fetchFromGitHub {
    owner = "MmgTools";
    repo = "mmg";
    rev = "5a73683f84fe422031921bef4ced8905d8b9eb7e";
    hash = "sha256-8m4iDsJdjlzuXatfIIZCY8RgrEp4BQihhmQfytu8aaU=";
  };

  passthru.updateScript = unstableGitUpdater { };

  nativeBuildInputs = [
    cmake
    perl
  ];

  preConfigure = ''
    patchShebangs ./
  '';

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS:BOOL=TRUE"
    "-DMMG_INSTALL_PRIVATE_HEADERS=ON"
  ];

  meta = {
    description = "Open source software for bidimensional and tridimensional remeshing";
    homepage = "http://www.mmgtools.org/";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ mkez ];
  };
}
