{
  lib,
  stdenv,
  fetchFromGitLab,
  writeText,
  bluez,
  cjson,
  cmake,
  dbus,
  doxygen,
  eigen,
  elfutils,
  ffmpeg,
  glslang,
  gst-plugins-base,
  gstreamer,
  hidapi,
  libbsd,
  libdrm,
  libffi,
  libGL,
  libjpeg,
  librealsense,
  libsurvive,
  libunwind,
  libusb1,
  libuv,
  libuvc,
  libv4l,
  libXau,
  libxcb,
  libXdmcp,
  libXext,
  libXrandr,
  onnxruntime,
  opencv4,
  openhmd,
  openvr,
  orc,
  pcre2,
  pkg-config,
  python3,
  SDL2,
  shaderc,
  udev,
  vulkan-headers,
  vulkan-loader,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zlib,
  zstd,
  nixosTests,
  # Set as 'false' to build monado without service support, i.e. allow VR
  # applications linking against libopenxr_monado.so to use OpenXR standalone
  # instead of via the monado-service program. For more information see:
  # https://gitlab.freedesktop.org/monado/monado/-/blob/master/doc/targets.md#xrt_feature_service-disabled
  serviceSupport ? true,
}:

stdenv.mkDerivation {
  pname = "monado";
  version = "unstable-2024-01-02";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado";
    repo = "monado";
    rev = "bfa1c16ff9fc759327ca251a5d086b958b1a3b8a";
    hash = "sha256-wXRwOs9MkDre/VeW686DzmvKjX0qCSS13MILbYQD6OY=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    glslang
    pkg-config
    python3
  ];

  cmakeFlags = [
    "-DXRT_FEATURE_SERVICE=${if serviceSupport then "ON" else "OFF"}"
    "-DXRT_OPENXR_INSTALL_ABSOLUTE_RUNTIME_PATH=ON"
  ];

  buildInputs = [
    bluez
    cjson
    dbus
    eigen
    elfutils
    ffmpeg
    gst-plugins-base
    gstreamer
    hidapi
    libbsd
    libdrm
    libffi
    libGL
    libjpeg
    librealsense
    libsurvive
    libunwind
    libusb1
    libuv
    libuvc
    libv4l
    libXau
    libxcb
    libXdmcp
    libXext
    libXrandr
    onnxruntime
    opencv4
    openhmd
    openvr
    orc
    pcre2
    SDL2
    shaderc
    udev
    vulkan-headers
    vulkan-loader
    wayland
    wayland-protocols
    wayland-scanner
    zlib
    zstd
  ];

  # known disabled drivers/features:
  #  - DRIVER_DEPTHAI - Needs depthai-core https://github.com/luxonis/depthai-core (See https://github.com/NixOS/nixpkgs/issues/292618)
  #  - DRIVER_ILLIXR - needs ILLIXR headers https://github.com/ILLIXR/ILLIXR (See https://github.com/NixOS/nixpkgs/issues/292661)
  #  - DRIVER_ULV2 - Needs proprietary Leapmotion SDK https://api.leapmotion.com/documentation/v2/unity/devguide/Leap_SDK_Overview.html (See https://github.com/NixOS/nixpkgs/issues/292624)
  #  - DRIVER_ULV5 - Needs proprietary Leapmotion SDK https://api.leapmotion.com/documentation/v2/unity/devguide/Leap_SDK_Overview.html (See https://github.com/NixOS/nixpkgs/issues/292624)

  # Help openxr-loader find this runtime
  setupHook = writeText "setup-hook" ''
    export XDG_CONFIG_DIRS=@out@/etc/xdg''${XDG_CONFIG_DIRS:+:''${XDG_CONFIG_DIRS}}
  '';

  patches = [
    # We don't have $HOME/.steam when building
    ./force-enable-steamvr_lh.patch
  ];

  passthru.tests = {
    basic-service = nixosTests.monado;
  };

  meta = with lib; {
    description = "Open source XR runtime";
    homepage = "https://monado.freedesktop.org/";
    license = licenses.boost;
    maintainers = with maintainers; [
      Scrumplex
      expipiplus1
      prusnak
    ];
    platforms = platforms.linux;
    mainProgram = "monado-cli";
  };
}
