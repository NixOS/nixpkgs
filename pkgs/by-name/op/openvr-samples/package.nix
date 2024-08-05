{
  lib,
  stdenv,
  openvr,
  cmake,
  pkg-config,
  libGL,
  glew,
  SDL2,
  vulkan-headers,
  vulkan-loader,
  libsForQt5
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "openvr-samples";

  inherit (openvr) version src;

  sourceRoot = "${finalAttrs.src.name}/samples";

  patches = [
    ./disable-steamvr-sdk-check.patch
    ./fix-output-path.patch
    ./use-system-deps.patch
    ./fix-assets-paths.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libGL
    glew
    SDL2
    vulkan-headers
    vulkan-loader
    openvr
    libsForQt5.qtbase
    libsForQt5.wrapQtAppsHook
  ];

  postUnpack = ''
    mkdir -p $sourceRoot/share
    mv $sourceRoot/bin/*.json $sourceRoot/bin/*.png $sourceRoot/bin/shaders $sourceRoot/share
    rm -rf $sourceRoot/bin $sourceRoot/thirdparty
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin \
      bin/hellovr_opengl \
      bin/hellovr_vulkan \
      bin/helloworldoverlay \
      bin/tracked_camera_openvr_sample

    install -d $out/share/openvr
    cp -Tr ../share $out/share/openvr

    runHook postInstall
  '';

  meta = openvr.meta // {
    description = "Example programs for OpenVR";
    maintainers = with lib.maintainers; [Scrumplex];
  };
})
