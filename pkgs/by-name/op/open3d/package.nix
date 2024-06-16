{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  withPython ? false,
  ispc,
  jsoncpp,
  vulkan-loader,
  vulkan-headers,
  glfw3,
  xorg,
  assimp,
  blas,
  curl,
  eigen,
  embree,
  glew,
  imgui,
  nasm,
  libjpeg,
  filament,
  libjpeg_turbo,
  libpng,
  libz,
  liblzf,
  msgpack,
  nanoflann,
  boringssl,
  qhull,
  stdgpu,
  tbb,
  draco,
  vtk,
  zeromq,
  config,
  cudaSupport ? false,
}:

let
  buildPkg = p: p.__spliced.buildHost or p;
in

stdenv.mkDerivation rec {
  pname = "open3d";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "isl-org";
    repo = "Open3D";
    rev = "v${version}";
    hash = "sha256-VMykWYfWUzhG+Db1I/9D1GTKd3OzmSXvwzXwaZnu8uI=";
  };

  postPatch = ''
    substituteInPlace "cmake/Open3DFetchISPCCompiler.cmake" \
      --replace-fail \
        'DOWNLOAD_DIR "''${OPEN3D_THIRD_PARTY_DOWNLOAD_DIR}/ispc"' \
        '
                DOWNLOAD_DIR "''${OPEN3D_THIRD_PARTY_DOWNLOAD_DIR}/ispc"
                FIND_PACKAGE_ARGS ispc
        '
    cat << \EOF > 3rdparty/jsoncpp/jsoncpp.cmake
    find_package(jsoncpp REQUIRED)
    add_library(jsoncpp ALIAS jsoncpp_lib)
    EOF
  '';

  nativeBuildInputs = [
    cmake
    ispc
    nasm
  ];

  buildInputs = [
    jsoncpp
    assimp
    blas
    curl
    eigen
    embree
    glew
    glfw3
    imgui
    libjpeg
    libjpeg_turbo
    libpng
    msgpack
    nanoflann
    boringssl
    qhull
    tbb
    draco # tinygltf
    vtk
    vulkan-headers
    vulkan-loader
    xorg.libX11
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    zeromq
    libz
    liblzf
    filament
  ] ++ lib.optionals cudaSupport [ stdgpu ];

  preConfigure = ''
    # Set all of the USE_SYSTEM_* variables
    while IFS= read name ; do
      cmakeFlags+=" -D''${name}:BOOL=ON"
    done < <(grep '\bUSE_SYSTEM[_a-zA-Z0-9]\+\b' --only-matching CMakeLists.txt)
    export cmakeFlags
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_MODULE" withPython)
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "FETCHCONTENT_TRY_FIND_PACKAGE_MODE" "ALWAYS")
    (lib.cmakeFeature "CMAKE_ISPC_COMPILER" (lib.getExe (buildPkg ispc)))
    (lib.cmakeFeature "BORINGSSL_ROOT_DIR" "${lib.getDev boringssl}")

    # Doesn't seem to generate a `*Config.cmake` file
    (lib.cmakeFeature "filament_DIR" "${lib.getDev filament}")
  ];

  meta = {
    description = "Open3D: A Modern Library for 3D Data Processing";
    homepage = "https://github.com/isl-org/Open3D/";
    changelog = "https://github.com/isl-org/Open3D/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
    mainProgram = "open3d";
    platforms = lib.platforms.all;
  };
}
