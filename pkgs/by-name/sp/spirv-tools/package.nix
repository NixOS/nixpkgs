{
  lib,
  stdenv,
  fetchFromGitHub,
  applyPatches,
  fetchpatch,
  cmake,
  python3,
  spirv-headers,
}:

stdenv.mkDerivation rec {
  pname = "spirv-tools";
  version = "1.4.321.0";

  # Several downstream derivations consume `spirv-tools.src`; apply
  # relevant patches here rather than in the main derivation.
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "SPIRV-Tools";
      rev = "vulkan-sdk-${version}";
      hash = "sha256-yAdd/mXY8EJnE0vCu0n/aVxMH9059T/7cAdB9nP1vQQ=";
    };

    patches = [
      # Fix the build with the corresponding backport in the headers.
      (fetchpatch {
        name = "spirv-tools-SPV_INTEL_function_variants.patch";
        url = "https://github.com/KhronosGroup/SPIRV-Tools/commit/28a883ba4c67f58a9540fb0651c647bb02883622.patch";
        hash = "sha256-zH8wI7Ilir0FEbJ3RzHn9b29Etn7ahMUWCFz0o7R6hE=";
      })
    ];
  };

  # The cmake options are sufficient for turning on static building, but not
  # for disabling shared building, just trim the shared lib from the CMake
  # description
  patches = lib.optional stdenv.hostPlatform.isStatic ./no-shared-libs.patch;

  nativeBuildInputs = [
    cmake
    python3
  ];

  cmakeFlags = [
    "-DSPIRV-Headers_SOURCE_DIR=${spirv-headers.src}"
    # Avoid blanket -Werror to evade build failures on less
    # tested compilers.
    "-DSPIRV_WERROR=OFF"
  ];

  # https://github.com/KhronosGroup/SPIRV-Tools/issues/3905
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '-P ''${CMAKE_CURRENT_SOURCE_DIR}/cmake/write_pkg_config.cmake' \
                     '-DCMAKE_INSTALL_FULL_LIBDIR=''${CMAKE_INSTALL_FULL_LIBDIR}
                     -DCMAKE_INSTALL_FULL_INCLUDEDIR=''${CMAKE_INSTALL_FULL_INCLUDEDIR}
                     -P ''${CMAKE_CURRENT_SOURCE_DIR}/cmake/write_pkg_config.cmake'
    substituteInPlace cmake/SPIRV-Tools.pc.in \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
    substituteInPlace cmake/SPIRV-Tools-shared.pc.in \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = with lib; {
    description = "SPIR-V Tools project provides an API and commands for processing SPIR-V modules";
    homepage = "https://github.com/KhronosGroup/SPIRV-Tools";
    license = licenses.asl20;
    platforms = with platforms; unix ++ windows;
    maintainers = [ maintainers.ralith ];
  };
}
