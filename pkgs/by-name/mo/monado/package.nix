{
  lib,
  stdenv,
  fetchFromGitLab,
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
  gst_all_1,
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
  openvr,
  orc,
  pcre2,
  pkg-config,
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
  # Only build client libraries to allow applications/games to connect to the monado IPC socket for VR eg, for 32 bit applications/games on a 64 bit host
  clientLibOnly ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "monado";
  version = "25.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado";
    repo = "monado";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hUSm76PV+FhvzhiYMUbGcNDQMK1TZCPYh1PNADJmdSU=";
  };

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
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
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
  ++ lib.optionals (!clientLibOnly) [
    onnxruntime
    opencv4
  ]
  ++ lib.optionals tracingSupport [
    tracy
  ]
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_cudart
  ];

  cmakeFlags = [
    (lib.cmakeBool "XRT_FEATURE_SERVICE" (serviceSupport && !clientLibOnly))
    (lib.cmakeBool "XRT_HAVE_TRACY" tracingSupport)
    (lib.cmakeBool "XRT_FEATURE_TRACING" tracingSupport)
    (lib.cmakeBool "XRT_OPENXR_INSTALL_ABSOLUTE_RUNTIME_PATH" true)
  ]
  ++ lib.optionals clientLibOnly [
    (lib.cmakeBool "XRT_FEATURE_CLIENT_WITHOUT_SERVICE" true)
    (lib.cmakeBool "XRT_FEATURE_STEAMVR_PLUGIN" false)
    (lib.cmakeBool "XRT_HAVE_LIBUVC" false)
    (lib.cmakeBool "XRT_HAVE_LIBUSB" false)
    (lib.cmakeBool "XRT_HAVE_JPEG" false)
    (lib.cmakeBool "XRT_HAVE_HIDAPI" false)
    (lib.cmakeBool "XRT_HAVE_GST" false)
    (lib.cmakeBool "XRT_HAVE_BLUETOOTH" false)
    (lib.cmakeBool "XRT_FEATURE_DEBUG_GUI" false)
    (lib.cmakeBool "XRT_FEATURE_WINDOW_PEEK" false)
    (lib.cmakeBool "XRT_FEATURE_SLAM" false)
    (lib.cmakeBool "XRT_MODULE_MONADO_CLI" false)
    (lib.cmakeBool "XRT_MODULE_MONADO_GUI" false)
    (lib.cmakeBool "XRT_MODULE_MERCURY_HANDTRACKING" false)
    (lib.cmakeBool "XRT_BUILD_SAMPLES" false)
  ];

  # Help openxr-loader find this runtime
  setupHook = writeText "setup-hook" ''
    export XDG_CONFIG_DIRS=@out@/etc/xdg''${XDG_CONFIG_DIRS:+:''${XDG_CONFIG_DIRS}}
  '';

  # While it seems like you could use stdenv.hostPlatform.parsed.cpu.arch for the next variable, you can't, as this always sets the correct host CPU, even if you're using i686 packages on x86_64
  # This may not be correct on every CPU architecture as per, https://registry.khronos.org/OpenXR/specs/1.1/loader.html#architecture-identifiers
  postInstall = ''
    cp "$out/share/openxr/1/openxr_monado.json" "$out/share/openxr/1/openxr_monado.${stdenv.hostPlatform.parsed.cpu.name}.json"
  ''; # Do not change this from using `cp` as this will break the multiarch build because it will be pointing to openxr_monado.json for both the 32 bit json and the 64 bit json.

  passthru = {
    updateScript = nix-update-script { };
    tests.basic-service = nixosTests.monado;
  };

  meta = {
    description = "Open source XR runtime";
    homepage = "https://monado.freedesktop.org/";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ Scrumplex ];
    mainProgram = "monado-cli";
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
    ];
  };
})
