{
  lib,
  stdenv,
  fetchFromGitHub,
  assimp,
  uvatlas,
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
  minizip,
  imgui,
  ispc,
  jsoncpp,
  lapack,
  libjpeg,
  libjpeg_turbo,
  liblzf,
  libpng,
  libz,
  mesa,
  mkl,
  msgpack,
  nanoflann,
  nasm,
  one-dpl,
  openblas,
  pkg-config,
  poisson-recon,
  qhull,
  stdgpu,
  tbbLatest,
  tinyobjloader,
  vtk,
  vulkan-headers,
  vulkan-loader,
  withMkl ? blas.provider.pname == "mkl",
  withPython ? false,
  xorg,
  zeromq,
  open3DRendering ? "gui",
}:

assert builtins.elem open3DRendering [
  "headless"
  "gui"
  null
];

let
  buildPkg = p: p.__spliced.buildHost or p;
in

stdenv.mkDerivation rec {
  pname = "open3d";
  version = "0.18.0";
  outputs = [
    "bin"
    "out"
    "dev"
  ];

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

    set(POISSON_INCLUDE_DIRS "${lib.getDev poisson-recon}/include")

    find_package(oneDPL REQUIRED GLOBAL)
    add_library(3rdparty_onedpl ALIAS oneDPL)
    add_library(ext_parallelstl ALIAS oneDPL)
    set(PARALLELSTL_INCLUDE_DIRS "${lib.getDev one-dpl}/include/")
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
        '# include(''${Open3D_3RDPARTY_DIR}/uvatlas/uvatlas.cmake)' \
      --replace-fail \
        "GLEW::GLEW" \
        "GLEW::glew" \
      --replace-fail \
        "PACKAGE GLEW" \
        "PACKAGE glew" \
      --replace-fail \
        "/usr/bin/matc" \
        "${lib.getExe' filament "matc"}"

    substituteInPlace cpp/open3d/t/io/file_format/FilePCD.cpp cpp/open3d/io/file_format/FilePCD.cpp \
      --replace-fail \
        '<liblzf/lzf.h>' \
        '<lzf.h>'
    sed -i "1r $extraFindPackagesPath" 3rdparty/find_dependencies.cmake

    rm -rf build/filament
    echo "" > 3rdparty/possionrecon/possionrecon.cmake
    echo "" > 3rdparty/parallelstl/parallelstl.cmake

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

  NIX_CFLAGS_COMPILE = [
    # Remove noise
    "-Wno-int-to-pointer-cast"

    # Whatever is wrogn with their buld system
    "-I${lib.getDev liblzf}/include"
    "-I${lib.getDev embree}/include"
  ];

  cmakeBuildDir = "builddir"; # build/ is checked in git

  nativeBuildInputs = [
    cmake
    ispc
    nasm
    pkg-config
  ];

  buildInputs =
    [
      assimp
      blas
      boringssl
      uvatlas
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
      lapack
      libjpeg
      libjpeg_turbo
      liblzf
      libpng
      libz
      msgpack
      nanoflann
      one-dpl
      poisson-recon
      qhull
      tbbLatest
      tinyobjloader
      vtk
      vulkan-headers
      vulkan-loader
      xorg.libX11
      xorg.libXcursor
      xorg.libXinerama
      xorg.libXrandr
      minizip # unzip.h
      zeromq
    ]
    ++ lib.optionals (open3DRendering == "headless") [
      mesa
      mesa.osmesa
    ]
    ++ lib.optionals cudaSupport [ stdgpu ]
    ++ lib.optionals withMkl [
      # Currently, the blas/lapack shims do not expose original package info
      # (e.g. the original cmake configs)
      mkl
    ]
    ++ lib.optionals (!withMkl) [ openblas ];

  preConfigure = ''
    # Set all of the USE_SYSTEM_* variables
    while IFS= read name ; do
      if [[ "$cmakeFlags" == *"$name":BOOL* ]] ; then
        continue
      fi
      cmakeFlags+=" -D''${name}:BOOL=ON"
    done < <(grep '\bUSE_SYSTEM[_a-zA-Z0-9]\+\b' --only-matching CMakeLists.txt)
    export cmakeFlags
  '';

  cmakeFlags =
    [
      (lib.cmakeBool "BUILD_PYTHON_MODULE" withPython)
      (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
      (lib.cmakeFeature "FETCHCONTENT_TRY_FIND_PACKAGE_MODE" "ALWAYS")
      (lib.cmakeBool "DEVELOPER_BUILD" false)

      # `USE_BLAS && USE_SYSTEM_BLAS` means `find_package(BLAS)`;
      # `!USE_BLAS && USE_SYSTEM_BLAS` means "download MKL from anaconda";
      # `USE_BLAS && !USE_SYSTEM_BLAS` means "build a vendored copy of openblas".
      (lib.cmakeBool "USE_SYSTEM_BLAS" true)
      (lib.cmakeBool "USE_BLAS" (!withMkl)) # "Use BLAS/LAPACK instead of MKL"

      # TBD; these fetch additional vendored dependencies
      (lib.cmakeBool "WITH_IPPICV" false) # "Intel Performance Primitives"
      (lib.cmakeBool "BUILD_WEBRTC" false) # A "WebRTC visualizer"
      (lib.cmakeBool "BUILD_VTK_FROM_SOURCE" false)
      (lib.cmakeBool "OPEN3D_USE_ONEAPI_PACKAGES" withMkl)
      (lib.cmakeBool "BUILD_SYCL_MODULE" false) # "Build SYCL module with Intel oneAPI"
      (lib.cmakeBool "PREFER_OSX_HOMEBREW" false)
      (lib.cmakeFeature "POISSON_INCLUDE_DIRS" "${lib.getDev poisson-recon}/include")

      (lib.cmakeFeature "CMAKE_ISPC_COMPILER" (lib.getExe (buildPkg ispc)))
      (lib.cmakeFeature "BORINGSSL_ROOT_DIR" "${lib.getDev boringssl}")

      # Doesn't seem to generate a `*Config.cmake` file
      (lib.cmakeFeature "filament_DIR" "${lib.getDev filament}/share/cmake")
      (lib.cmakeFeature "FILAMENT_PRECOMPILED_ROOT" "${lib.getLib filament}")

      # Should work without this but it doesn't
      (lib.cmakeFeature "TinyGLTF_DIR" "${lib.getDev draco.tinygltf}/lib/cmake")

      (lib.cmakeBool "BUILD_GUI" (open3DRendering == "gui"))
      (lib.cmakeBool "ENABLE_HEADLESS_RENDERING" (open3DRendering == "headless"))
    ]
    ++ lib.optionals (open3DRendering == "headless") [
      (lib.cmakeFeature "OSMESA_INCLUDE_DIR" "${lib.getDev mesa}/include")
      (lib.cmakeFeature "OSMESA_ROOT" "${lib.getDev mesa}")
      # (lib.cmakeFeature "OSMESA_ROOT" "${lib.getOutput "osmesa" mesa}")
      # Somehow, open3d overrides OSMESA_INCLUDE_DIR if it locates OSMESA_LIBRARY via OSMESA_ROOT
      (lib.cmakeFeature "OSMESA_LIBRARY" "${lib.getOutput "osmesa" mesa}/lib/libOSMesa${stdenv.hostPlatform.extensions.sharedLibrary}")
    ];

  meta = {
    broken = withMkl || cudaSupport;
    description = "Open3D: A Modern Library for 3D Data Processing";
    homepage = "https://github.com/isl-org/Open3D/";
    changelog = "https://github.com/isl-org/Open3D/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
    mainProgram = "open3d";
    platforms = lib.platforms.all;
  };
}
