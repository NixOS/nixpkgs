{
  cmake,
  fetchFromGitHub,
  git,
  lib,
  qt6,
  stdenv,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fdt-viewer";
  version = "0-unstable-2024-12-06";

  src = fetchFromGitHub {
    owner = "dev-0x7C6";
    repo = "fdt-viewer";
    rev = "3488a599bfe0a92a0aec3cf421ef0c6f385f0737";
    hash = "sha256-THu6HZpVSqsU2M/5AVflTaW8l8FNSYVI/f1kbZ+zCsA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    cmake
    git
  ];

  buildInputs = [ qt6.qtbase ];

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Flattened Device Tree Viewer written in Qt";
    homepage = "https://github.com/dev-0x7C6/fdt-viewer";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jmbaur ];
    mainProgram = "fdt-viewer";
    platforms = lib.platforms.all;
  };
})
