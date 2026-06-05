{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  cmake,
  libcaesium,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "caesium-image-compressor";
  version = "2.8.5";

  src = fetchFromGitHub {
    owner = "Lymphatus";
    repo = "caesium-image-compressor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uzDbi6J18BVccm9d8yhLRPPJXdt7parwE19zOfCAwnY=";
  };

  patches = [
    ./add-missing-include.patch
    ./cmake-prefix-qt.patch
    ./libcaesium-fix.patch
    ./disable-sparkle-updates.patch
    ./macos-install.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    cmake
  ];

  buildInputs = [
    libcaesium
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
  ];

  # not sure why the path for libcaesium.dylib is being set to /nix/var/nix/builds/.../
  # so just fixing it at the end
  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    ln -s "$out/bin/Caesium Image Compressor" $out/bin/caesium-image-compressor
    lib=$(otool -L "$out/bin/caesium-image-compressor" | grep 'libcaesium.dylib' | awk '{print $1}')
    install_name_tool -change "$lib" ${libcaesium}/lib/libcaesium.dylib $out/bin/caesium-image-compressor
  '';

  meta = {
    description = "Reduce file size while preserving the overall quality of the image";
    homepage = "https://github.com/Lymphatus/caesium-image-compressor";
    license = lib.licenses.gpl3Only;
    mainProgram = "caesium-image-compressor";
    maintainers = with lib.maintainers; [ phanirithvij ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
