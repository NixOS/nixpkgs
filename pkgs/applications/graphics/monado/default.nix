{ lib
, stdenv
, fetchFromGitLab
, writeText
, cmake
, doxygen
, glslang
, pkg-config
, python3
, SDL2
<<<<<<< HEAD
, bluez
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, dbus
, eigen
, ffmpeg
, gst-plugins-base
, gstreamer
, hidapi
, libGL
, libXau
, libXdmcp
, libXrandr
, libbsd
, libffi
, libjpeg
# , librealsense
, libsurvive
, libusb1
, libuv
, libuvc
, libv4l
, libxcb
<<<<<<< HEAD
, onnxruntime
, opencv4
, openhmd
, openvr
=======
, opencv4
, openhmd
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, udev
, vulkan-headers
, vulkan-loader
, wayland
, wayland-protocols
, wayland-scanner
, libdrm
, zlib
# Set as 'false' to build monado without service support, i.e. allow VR
# applications linking against libopenxr_monado.so to use OpenXR standalone
# instead of via the monado-service program. For more information see:
# https://gitlab.freedesktop.org/monado/monado/-/blob/master/doc/targets.md#xrt_feature_service-disabled
, serviceSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "monado";
<<<<<<< HEAD
  version = "unstable-2023-08-22";
=======
  version = "unstable-2023-01-14";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado";
    repo = "monado";
<<<<<<< HEAD
    rev = "4cc68f07c0f3c2fee57b01dde28a02e314d3bee6";
    sha256 = "sha256-VibdOSA/b4RmwwwXrwhivuiukNK10YazYF/p+YnqRZ8=";
=======
    rev = "1ef49b92f2d6cb519039edd7ba7f70e8073fbe88";
    sha256 = "sha256-zieJmI6BKHpYyCPOOUora9qoWn+NXehbHKvoi4h81UA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    SDL2
<<<<<<< HEAD
    bluez
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    dbus
    eigen
    ffmpeg
    gst-plugins-base
    gstreamer
    hidapi
    libGL
    libXau
    libXdmcp
    libXrandr
    libbsd
    libjpeg
    libffi
    # librealsense.dev - see below
    libsurvive
    libusb1
    libuv
    libuvc
    libv4l
    libxcb
<<<<<<< HEAD
    onnxruntime
    opencv4
    openhmd
    openvr
=======
    opencv4
    openhmd
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    udev
    vulkan-headers
    vulkan-loader
    wayland
    wayland-scanner
    wayland-protocols
    libdrm
    zlib
  ];

<<<<<<< HEAD
  # known disabled drivers:
  #  - DRIVER_DEPTHAI - Needs depthai-core https://github.com/luxonis/depthai-core
  #  - DRIVER_ILLIXR - needs ILLIXR headers https://github.com/ILLIXR/ILLIXR
  #  - DRIVER_REALSENSE - see below
  #  - DRIVER_SIMULAVR - needs realsense
  #  - DRIVER_ULV2 - needs proprietary Leapmotion SDK https://api.leapmotion.com/documentation/v2/unity/devguide/Leap_SDK_Overview.html

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # realsense is disabled, the build ends with the following error:
  #
  # CMake Error in src/xrt/drivers/CMakeLists.txt:
  # Imported target "realsense2::realsense2" includes non-existent path
  # "/nix/store/2v95aps14hj3jy4ryp86vl7yymv10mh0-librealsense-2.41.0/include"
  # in its INTERFACE_INCLUDE_DIRECTORIES.
  #
  # for some reason cmake is trying to use ${librealsense}/include
  # instead of ${librealsense.dev}/include as an include directory

  # Help openxr-loader find this runtime
  setupHook = writeText "setup-hook" ''
    export XDG_CONFIG_DIRS=@out@/etc/xdg''${XDG_CONFIG_DIRS:+:''${XDG_CONFIG_DIRS}}
  '';

<<<<<<< HEAD
  patches = [
    # We don't have $HOME/.steam when building
    ./force-enable-steamvr_lh.patch

    # A recent (as of August 2023) SteamVR Beta has upgraded a driver interface which is incompatible with Monado
    ./steamvr_lh-use-old-interface.patch
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Open source XR runtime";
    homepage = "https://monado.freedesktop.org/";
    license = licenses.boost;
    maintainers = with maintainers; [ expipiplus1 prusnak ];
    platforms = platforms.linux;
    mainProgram = "monado-cli";
  };
}
