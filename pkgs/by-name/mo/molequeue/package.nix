{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt5,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "molequeue";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "molequeue";
    tag = finalAttrs.version;
    hash = "sha256-+NoY8YVseFyBbxc3ttFWiQuHQyy1GN8zvV1jGFjmvLg=";
  };

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [ qt5.qttools ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.3 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
  '';

  # Fix the broken CMake files to use the correct paths
  postInstall = ''
    substituteInPlace $out/lib/cmake/molequeue/MoleQueueConfig.cmake \
      --replace "$out/" ""
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop integration of high performance computing resources";
    mainProgram = "molequeue";
    maintainers = with lib.maintainers; [ sheepforce ];
    homepage = "https://github.com/OpenChemistry/molequeue";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
  };
})
