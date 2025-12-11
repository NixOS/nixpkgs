{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  nasm,
  libpng,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "efficient-compression-tool";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "fhanau";
    repo = "Efficient-Compression-Tool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mlqRDYwgLiB/mRaXkkPTCLiDGxTXqEgu5Nz5jhr1Hsg=";
    fetchSubmodules = true;
  };

  # devendor libpng
  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail 'if(EXISTS "''${CMAKE_SOURCE_DIR}/../.git" AND NOT EXISTS "''${CMAKE_SOURCE_DIR}/../src/libpng/README")' 'if(False)' \
      --replace-fail 'file(COPY ''${CMAKE_SOURCE_DIR}/pngusr.h DESTINATION ''${CMAKE_SOURCE_DIR}/libpng/)' ""
    substituteInPlace src/optipng/CMakeLists.txt \
      --replace-fail 'set(PNG_BUILD_ZLIB ON CACHE BOOL "use custom zlib within libpng" FORCE)' "" \
      --replace-fail 'add_subdirectory(../libpng libpng EXCLUDE_FROM_ALL)' "" \
      --replace-fail 'png_static)' 'png)'
    substituteInPlace src/optipng/image.h src/optipng/trans.h \
      --replace-fail '#include "../libpng/png.h"' '#include <png.h>'
    substituteInPlace src/optipng/opngreduc/opngreduc.h \
      --replace-fail '#include "../../libpng/png.h"' '#include <png.h>'
  '';

  nativeBuildInputs = [
    cmake
    nasm
  ];

  buildInputs = [
    boost
    libpng
  ];

  cmakeDir = "../src";

  cmakeFlags = [ "-DECT_FOLDER_SUPPORT=ON" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  versionCheckProgramArg = "-help";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fast and effective C++ file optimizer";
    homepage = "https://github.com/fhanau/Efficient-Compression-Tool";
    changelog = "https://github.com/fhanau/Efficient-Compression-Tool/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jwillikers
      lunik1
    ];
    platforms = lib.platforms.all;
    mainProgram = "ect";
  };
})
