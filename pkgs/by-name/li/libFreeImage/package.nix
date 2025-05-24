{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  openexr,
  zlib,
  libraw,
  openjpeg,
  jxrlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfreeimage";
  version = "0-unstable-2024-11-28";

  src = fetchFromGitHub {
    owner = "WohlSoft";
    repo = "libFreeImage";
    rev = "2666dee8132384885dd501a6a6db1bd86016ce0e";
    hash = "sha256-aLIDhAMSE9ESepWeEOPFu6Ry2WSiS9M43GXOKuTcft8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libjpeg
    libpng
    libtiff
    libwebp
    openexr
    zlib
    libraw
    openjpeg
    jxrlib
  ];

  # Disable treating warnings as errors
  NIX_CFLAGS_COMPILE = "-Wno-error -Wno-format -Wno-format-security -fpermissive";

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DFREEIMAGE_DYNAMIC_C_RUNTIME=ON"
  ];

  # More thorough patching of build files
  preConfigure = ''
    # Find and modify CMakeLists.txt to remove -Werror flags
    find . -name CMakeLists.txt -exec sed -i 's/-Werror//g' {} \;
    find . -name "*.cmake" -exec sed -i 's/-Werror//g' {} \;

    # Add compiler flags to disable warnings as errors
    echo 'add_compile_options(-Wno-error -Wno-format -Wno-format-security -fpermissive)' >> CMakeLists.txt

    # If there's a specific compiler flags setup file, modify it
    if [ -f CMake/CompilerFlags.cmake ]; then
      sed -i 's/add_compile_options(-Werror)//g' CMake/CompilerFlags.cmake
      echo 'add_compile_options(-Wno-error -Wno-format -Wno-format-security -fpermissive)' >> CMake/CompilerFlags.cmake
    fi
  '';

  meta = {
    description = "Open source library to work with graphical file formats";
    longDescription = ''
      FreeImage is an Open Source library project for developers who would like
      to support popular graphics image formats like PNG, BMP, JPEG, TIFF and
      others as needed by today's multimedia applications. FreeImage is easy to
      use, fast, multithreading safe, compatible with all 32-bit or 64-bit
      versions of Windows, and cross-platform (works both with Linux and Mac
      OS X).
    '';
    homepage = "https://github.com/WohlSoft/libFreeImage";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})
