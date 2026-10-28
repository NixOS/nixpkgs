{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pe-bear";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "hasherezade";
    repo = "pe-bear";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a/MAxJxr0FavWd+0Zdv8LH6hJ3HTLpj3Nmaz3yGgMGA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
  ];

  meta = {
    description = "Portable Executable reversing tool with a friendly GUI";
    mainProgram = "PE-bear";
    homepage = "https://hshrzd.wordpress.com/pe-bear/";

    license = with lib.licenses; [
      # PE-Bear
      gpl2Only

      # Vendored capstone
      bsd3

      # Vendored bearparser
      bsd2
    ];

    maintainers = [ lib.maintainers.blitz ];
    platforms = lib.platforms.linux;
  };
})
