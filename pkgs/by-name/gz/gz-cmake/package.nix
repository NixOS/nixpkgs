{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gz-cmake";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-cmake";
    rev = "gz-cmake${lib.head (lib.splitString "." finalAttrs.version)}_${finalAttrs.version}";
    hash = "sha256-r1XQqx+JqH+ITZIaixgZjA/9weyPq8+LQ1N2ZsIdOK4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  strictDeps = true;

  postPatch = ''
    # Install under lib/cmake instead of share/cmake
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(gz_config_install_dir "''${CMAKE_INSTALL_DATAROOTDIR}/cmake/''${PROJECT_NAME_LOWER}")' 'set(gz_config_install_dir "''${GZ_LIB_INSTALL_DIR}/cmake/''${PROJECT_NAME_LOWER}")' \
  '';

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A set of CMake modules that are used by the C++-based Gazebo projects";
    homepage = "https://github.com/gazebosim/gz-cmake";
    changelog = "https://github.com/gazebosim/gz-cmake/blob/${finalAttrs.src.rev}/Changelog.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    mainProgram = "gz-cmake";
    platforms = lib.platforms.all;
  };
})
