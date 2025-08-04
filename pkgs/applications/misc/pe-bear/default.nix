{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qtbase,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "pe-bear";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "hasherezade";
    repo = "pe-bear";
    rev = "v${version}";
    hash = "sha256-jWRO0vO601IijFo7nu0SMF8inEXWLzv+Ni1nlJfGqhQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  meta = {
    description = "Portable Executable reversing tool with a friendly GUI";
    mainProgram = "PE-bear";
    homepage = "https://hshrzd.wordpress.com/pe-bear/";

    license = [
      # PE-Bear
      lib.licenses.gpl2Only

      # Vendored capstone
      lib.licenses.bsd3

      # Vendored bearparser
      lib.licenses.bsd2
    ];

    maintainers = with lib.maintainers; [ blitz ];
    platforms = lib.platforms.linux;
  };
}
