{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch2,
  writeText,
  bluez,
  cjson,
  cmake,
  config,
  dbus,
  doxygen,
  eigen,
  elfutils,
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
  nix-update-script,
  onnxruntime,
  opencv4,
  openhmd,
  openvr,
  orc,
  pcre2,
  pkg-config,
  protobuf_21,
  python3,
  SDL2,
  shaderc,
  tracy,
  udev,
  vulkan-headers,
  vulkan-loader,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zlib,
  zstd,
  nixosTests,
  cudaPackages,
  enableCuda ? config.cudaSupport,
  # Set as 'false' to build monado without service support, i.e. allow VR
  # applications linking against libopenxr_monado.so to use OpenXR standalone
  # instead of via the monado-service program. For more information see:
  # https://gitlab.freedesktop.org/monado/monado/-/blob/master/doc/targets.md#xrt_feature_service-disabled
  serviceSupport ? true,
  tracingSupport ? false,
}:
let
  # For some reason protobuf 32 causes a segfault during startup
  # Pin to last (known) working version
  # See https://github.com/NixOS/nixpkgs/issues/439075
  opencv4' = opencv4.override {
    protobuf = protobuf_21;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "monado";
  version = "25.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado";
    repo = "monado";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VxTxvw+ftqlh3qF5qWxpK1OJsRowkRXu0xEH2bDckUA=";
  };

  patches = [
    # Remove with v26
    (fetchpatch2 {
      url = "https://gitlab.freedesktop.org/monado/monado/-/commit/2a6932d46dad9aa957205e8a47ec2baa33041076.patch";
      hash = "sha256-CZMbGgx7mEDcjcoRJHDZ5P6BecFW8CB4fpzxQ9bpAvE=";
    })
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    glslang
    pkg-config
    python3
  ];

  # known disabled drivers/features:
  #  - DRIVER_DEPTHAI - Needs depthai-core https://github.com/luxonis/depthai-core (See https://github.com/NixOS/nixpkgs/issues/292618)
  #  - DRIVER_ILLIXR - needs ILLIXR headers https://github.com/ILLIXR/ILLIXR (See https://github.com/NixOS/nixpkgs/issues/292661)
  #  - DRIVER_ULV2 - Needs proprietary Leapmotion SDK https://api.leapmotion.com/documentation/v2/unity/devguide/Leap_SDK_Overview.html (See https://github.com/NixOS/nixpkgs/issues/292624)
  #  - DRIVER_ULV5 - Needs proprietary Leapmotion SDK https://api.leapmotion.com/documentation/v2/unity/devguide/Leap_SDK_Overview.html (See https://github.com/NixOS/nixpkgs/issues/292624)

  buildInputs = [
    bluez
    cjson
    dbus
    eigen
    elfutils
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
    opencv4'
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
  ]
  ++ lib.optionals tracingSupport [
    tracy
  ]
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_cudart
  ];

  cmakeFlags = [
    (lib.cmakeBool "XRT_FEATURE_SERVICE" serviceSupport)
    (lib.cmakeBool "XRT_HAVE_TRACY" tracingSupport)
    (lib.cmakeBool "XRT_FEATURE_TRACING" tracingSupport)
    (lib.cmakeBool "XRT_OPENXR_INSTALL_ABSOLUTE_RUNTIME_PATH" true)
  ];

  # Help openxr-loader find this runtime
  setupHook = writeText "setup-hook" ''
    export XDG_CONFIG_DIRS=@out@/etc/xdg''${XDG_CONFIG_DIRS:+:''${XDG_CONFIG_DIRS}}
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.basic-service = nixosTests.monado;
  };

  meta = {
    description = "Open source XR runtime";
    homepage = "https://monado.freedesktop.org/";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ Scrumplex ];
    platforms = lib.platforms.linux;
    mainProgram = "monado-cli";
  };
})
