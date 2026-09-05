{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchurl,

  cmake,
  ninja,
  pkg-config,

  directx-headers,
  directxmath,

  llvmPackages,
  openexr,
  libjpeg,
  libpng,

  withOpenMpSupport ? true, # Enable the use of OpenMP for software BC6H/BC7 compression
  withOpenExrSupport ? true, # Build with OpenEXR support
  withJpegSupport ? true, # Build with libjpeg support
  withPngSupport ? true, # Build with libpng support
}:
let
  sal-stub = stdenv.mkDerivation {
    name = "sal-stub";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/dotnet/corert/9d8bd29a71f68941aaa2c00e9c9a0eed86cafa10/src/Native/inc/unix/sal.h";
      hash = "sha256-u56nwdBc38EKF/6A2Hp80WDBBjx+X6CJzWQFwxxhChs=";
    };
    dontUnpack = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/include
      cp $src $out/include/sal.h
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "directxtex";
  version = "2.0.7"; # DIRECTXTEX_VERSION in CMakeLists.txt

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectXTex";
    tag = "mar2025";
    hash = "sha256-7XAQePWFkErUkfrMZ3bx3oE5KjPAlSyMc0orCHSBUgE=";
  };

  patches = [
    ./cmake.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs =
    [
      directx-headers
      directxmath
      sal-stub
    ]
    ++ lib.optionals withOpenMpSupport [ llvmPackages.openmp ]
    ++ lib.optionals withOpenExrSupport [ openexr ]
    ++ lib.optionals withJpegSupport [ libjpeg ]
    ++ lib.optionals withPngSupport [ libpng ];

  cmakeFlags = [
    # Build tex command-line tools.
    # "Command-line tool is only supported for Win32 currently"
    # See: https://github.com/microsoft/DirectXTex/pull/208
    (lib.cmakeBool "BUILD_TOOLS" false)
    # Build DirectXTex as a shared library
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    # (lib.cmakeBool "BUILD_DX11" false)
    # (lib.cmakeBool "BUILD_DX12" false)
    (lib.cmakeBool "BC_USE_OPENMP" withOpenMpSupport)
    (lib.cmakeBool "ENABLE_OPENEXR_SUPPORT" withOpenExrSupport)
    (lib.cmakeBool "ENABLE_LIBJPEG_SUPPORT" withJpegSupport)
    (lib.cmakeBool "ENABLE_LIBPNG_SUPPORT" withPngSupport)
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-I${directx-headers}/include/wsl/stubs")
  ];

  meta = {
    description = "DirectX Texture Library";
    homepage = "https://github.com/microsoft/DirectXTex";
    changelog = "https://github.com/microsoft/DirectXTex/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ griffi-gh ];
    platforms = lib.platforms.all;
  };
})
