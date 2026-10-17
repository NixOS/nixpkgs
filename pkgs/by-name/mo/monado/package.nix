{
  SDL2,
  bluez,
  cjson,
  cmake,
  config,
  cudaPackages,
  dbus,
  doxygen,
  eigen,
  fetchFromGitLab,
  fetchpatch,
  glslang,
  gst_all_1,
  hidapi,
  lib,
  libGL,
  libbsd,
  libdrm,
  librealsense,
  libsurvive,
  libunwind,
  libusb1,
  libuvc,
  libv4l,
  libx11,
  libxcb,
  libxrandr,
  nix-update-script,
  nixosTests,
  onnxruntime,
  opencv4,
  openvr,
  pkg-config,
  python3,
  stdenv,
  tracy,
  udev,
  vulkan-headers,
  vulkan-loader,
  wayland,
  wayland-protocols,
  wayland-scanner,
  writeText,
  zlib,

  enableCuda ? config.cudaSupport,
  # Set as 'false' to build monado without service support, i.e. allow VR
  # applications linking against libopenxr_monado.so to use OpenXR standalone
  # instead of via the monado-service program. For more information see:
  # https://gitlab.freedesktop.org/monado/monado/-/blob/master/doc/targets.md#xrt_feature_service-disabled
  serviceSupport ? true,
  tracingSupport ? false,
  # Only build client libraries to allow applications/games to connect to the
  # monado IPC socket for VR eg, for 32 bit applications/games on a 64 bit host
  clientLibOnly ? false,
  enabledDrivers ? null,
}:
let
  driverInputs = {
    # android unsupported
    arduino = [
      dbus
    ];
    blubur_s1 = [ ];
    daydream = [
      dbus
    ];
    # depthai unsupported (https://github.com/NixOS/nixpkgs/issues/292618)
    euroc = [ opencv4 ];
    handtracking = [
      opencv4
      onnxruntime
    ];
    twrap = [ ];
    hdk = [ ];
    hydra = [ ];
    # illixr unsupported
    ns = [ ];
    # ohmd unsupported
    opengloves = [
      bluez
      # udev is required anyway on Linux so it's not listed here
    ];
    psmv = [ ];
    pssense = [ ];
    psvr = [ hidapi ];
    qwerty = [ SDL2 ];
    realsense = [ librealsense ];
    remote = [ ];
    rift = [ ];
    rift_s = [ libv4l ];
    rokid = [ libusb1 ];
    steamvr_lighthouse = [ ];
    survive = [ libsurvive ];
    # ulv2 unsupported (https://github.com/NixOS/nixpkgs/issues/292624)
    # ulv5 supported (https://github.com/NixOS/nixpkgs/issues/292624)
    vf = [
      gst_all_1.gst-plugins-base
      gst_all_1.gstreamer
    ];
    vive = [ zlib ];
    wmr = [ ];
    xreal_air = [ hidapi ];
    simulavr = [ librealsense ];
  };
in
assert
  clientLibOnly
  ->
    serviceSupport || throw "monado: serviceSupport must be enabled when building with clientLibOnly";
assert
  clientLibOnly
  ->
    (enabledDrivers == null)
    || throw "monado: enabledDrivers must be null when building with clientLibOnly";
stdenv.mkDerivation (finalAttrs: {
  pname = "monado";
  version = "25.1.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado";
    repo = "monado";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hUSm76PV+FhvzhiYMUbGcNDQMK1TZCPYh1PNADJmdSU=";
  };

  patches = [
    # Resolves issues with wayvr
    # See https://github.com/NixOS/nixpkgs/pull/489154#issuecomment-4018732528
    (fetchpatch {
      name = "monado-cylinder-aspectRatio.patch";
      url = "https://gitlab.freedesktop.org/monado/monado/-/commit/69834fe93b84640170f8efa54b4700e5e0dc03c1.diff";
      hash = "sha256-6lD4j7CMQk52btfxD8hOm0GWZaOxSgc1jel9hyXqktA=";
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
    cjson
    eigen
    libbsd # maybe unused for client lib
    libGL
    libx11
    libxrandr
    openvr
    udev
    vulkan-headers
    vulkan-loader
  ]
  ++ lib.optionals (!clientLibOnly) [
    libdrm
    libuvc # used in state trackers; unused by drivers?
    libxcb
    onnxruntime
    opencv4
    wayland
    wayland-protocols
    wayland-scanner
  ]
  ++ lib.optionals tracingSupport [
    libunwind
    tracy
  ]
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_cudart
  ]
  ++ lib.concatAttrValues (lib.getAttrs finalAttrs.enabledDrivers driverInputs);

  cmakeFlags = [
    (lib.cmakeBool "XRT_FEATURE_SERVICE" (serviceSupport && !clientLibOnly))
    (lib.cmakeBool "XRT_HAVE_TRACY" tracingSupport)
    (lib.cmakeBool "XRT_FEATURE_TRACING" tracingSupport)
    (lib.cmakeBool "XRT_OPENXR_INSTALL_ABSOLUTE_RUNTIME_PATH" true)
  ]
  ++ lib.optionals clientLibOnly [
    (lib.cmakeBool "XRT_FEATURE_CLIENT_WITHOUT_SERVICE" true)
    (lib.cmakeBool "XRT_FEATURE_STEAMVR_PLUGIN" false)
    (lib.cmakeBool "XRT_FEATURE_DEBUG_GUI" false)
    (lib.cmakeBool "XRT_FEATURE_WINDOW_PEEK" false)
    (lib.cmakeBool "XRT_FEATURE_SLAM" false)
    (lib.cmakeBool "XRT_MODULE_MONADO_CLI" false)
    (lib.cmakeBool "XRT_MODULE_MONADO_GUI" false)
    (lib.cmakeBool "XRT_BUILD_SAMPLES" false)
  ];

  # Help openxr-loader find this runtime
  setupHook =
    if clientLibOnly then
      null
    else
      writeText "setup-hook" ''
        export XDG_CONFIG_DIRS=@out@/etc/xdg''${XDG_CONFIG_DIRS:+:''${XDG_CONFIG_DIRS}}
      '';

  # It happens to be that stdenv.hostPlatform.parsed.cpu.name contains the
  # right architecturen ames for the systems we support
  # See https://registry.khronos.org/OpenXR/specs/1.1/loader.html#architecture-identifiers
  postInstall = ''
    ln -s "$out/share/openxr/1/openxr_monado.json" "$out/share/openxr/1/openxr_monado.${stdenv.hostPlatform.parsed.cpu.name}.json"
  '';

  # The symlink created above has to point to the absolute store path, as multi-arch builds may be symlinkJoin-ed
  dontRewriteSymlinks = true;

  passthru = {
    updateScript = nix-update-script { };
    tests.basic-service = nixosTests.monado;
  };

  enabledDrivers =
    if enabledDrivers == null then
      (if clientLibOnly then [ ] else builtins.attrNames driverInputs)
    else
      enabledDrivers;

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
      "armv7a-vfp-linux"
      "armv5te-linux"
      "mips64-linux"
      "mips-linux"
      "ppc64-linux"
      "ppc64el-linux"
      "s390x-linux"
      "hppa-linux"
      "alpha-linux"
      "ia64-linux"
      "m68k-linux"
      "riscv64-linux"
      "sparc64-linux"
      "loongarch64-linux"
    ];
  };
})
