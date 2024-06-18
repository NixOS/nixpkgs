{
  lib,
  stdenv,
  fetchFromGitHub,
  assimp,
  blas,
  boringssl,
  cmake,
  config,
  cudaSupport ? config.cudaSupport,
  curl,
  draco,
  eigen,
  embree,
  filament,
  fmt,
  glew,
  glfw3,
  imgui,
  ispc,
  jsoncpp,
  libjpeg,
  libjpeg_turbo,
  liblzf,
  libpng,
  libz,
  msgpack,
  nanoflann,
  nasm,
  pkg-config,
  poisson-recon,
  qhull,
  stdgpu,
  tbb,
  tinyobjloader,
  vtk,
  vulkan-headers,
  vulkan-loader,
  withPython ? false,
  xorg,
  zeromq,
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

  patches = [ ./0001-cmake-correct-msgpack-package-name.patch ];

  extraCmakeFindModules = [
    ./Findfilament.cmake
    ./Findliblzf.cmake
  ];
  extraFindPackages = ''
    find_package(msgpack REQUIRED GLOBAL)
    find_package(TinyGLTF REQUIRED GLOBAL)
    add_library(TinyGLTF::TinyGLTF ALIAS tinygltf::tinygltf)
  '';
  passAsFile = [ "extraFindPackages" ];

  postPatch = ''
    substituteInPlace "cmake/Open3DFetchISPCCompiler.cmake" \
      --replace-fail \
        'DOWNLOAD_DIR "''${OPEN3D_THIRD_PARTY_DOWNLOAD_DIR}/ispc"' \
        '
                DOWNLOAD_DIR "''${OPEN3D_THIRD_PARTY_DOWNLOAD_DIR}/ispc"
                FIND_PACKAGE_ARGS ispc
        '

    substituteInPlace 3rdparty/find_dependencies.cmake \
      --replace-fail \
        'include(''${Open3D_3RDPARTY_DIR}/uvatlas/uvatlas.cmake)' \
        '# include(''${Open3D_3RDPARTY_DIR}/uvatlas/uvatlas.cmake)'

    sed -i "1r $extraFindPackagesPath" 3rdparty/find_dependencies.cmake

    rm -rf build/filament

    echo "Installing extraCmakeFindModules" >&2
    mkdir -p cmake/
    for path in $extraCmakeFindModules ; do
      # Strip the hash bit to get the basename
      name="$(echo "$path" | sed 's|${builtins.storeDir}[^-]\+-||')"
      echo "Installing $path to ./cmake/$name" >&2
      cp "$path" ./cmake/"$name"
    done
    addToSearchPath CMAKE_MODULE_PATH "$PWD/cmake"
  '';

  cmakeBuildDir = "builddir"; # build/ is checked in git

  nativeBuildInputs = [
    cmake
    ispc
    nasm
    pkg-config
  ];

  buildInputs = [
    assimp
    blas
    boringssl
    curl
    draco.tinygltf
    eigen
    embree
    filament
    fmt
    glew
    glfw3
    imgui
    jsoncpp
    libjpeg
    libjpeg_turbo
    liblzf
    libpng
    libz
    msgpack
    nanoflann
    poisson-recon
    qhull
    tbb
    tinyobjloader
    vtk
    vulkan-headers
    vulkan-loader
    xorg.libX11
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXrandr
    zeromq
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
    (lib.cmakeFeature "filament_DIR" "${lib.getDev filament}/share/cmake")

    # Should work without this but it doesn't
    (lib.cmakeFeature "TinyGLTF_DIR" "${lib.getDev draco.tinygltf}/lib/cmake")
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
