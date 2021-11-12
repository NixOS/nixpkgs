{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, writeText
, cmake
, doxygen
, glslang
, pkg-config
, python3
, SDL2
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
, libffi
, libjpeg
# , librealsense
, libsurvive
, libusb1
, libuv
, libuvc
, libv4l
, libxcb
, opencv4
, openhmd
, udev
, vulkan-headers
, vulkan-loader
, wayland
, wayland-protocols
, zlib
# Set as 'false' to build monado without service support, i.e. allow VR
# applications linking against libopenxr_monado.so to use OpenXR standalone
# instead of via the monado-service program. For more information see:
# https://gitlab.freedesktop.org/monado/monado/-/blob/master/doc/targets.md#xrt_feature_service-disabled
, serviceSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "monado";
  version = "21.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "07zxs96i3prjqww1f68496cl2xxqaidx32lpfyy0pn5am4c297zc";
  };

  patches = [
    # https://github.com/NixOS/nixpkgs/issues/137245
    # Fix warning after Vulkan 1.2.174 VK_NULL_HANDLE change
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/monado/monado/-/commit/c47775a95d8e139a2f234063793eb6726f830510.patch";
      sha256 = "093ymvi9ifpk4vyjcwhhci9cnscxwbv5f80xdbppcqa0j92nmkmp";
    })
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    glslang
    pkg-config
    python3
  ];

  cmakeFlags = [
    "-DXRT_FEATURE_SERVICE=${if serviceSupport then "ON" else "OFF"}"
  ];

  buildInputs = [
    SDL2
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
    libjpeg
    libffi
    # librealsense.dev - see below
    libsurvive
    libusb1
    libuv
    libuvc
    libv4l
    libxcb
    opencv4
    openhmd
    udev
    vulkan-headers
    vulkan-loader
    wayland
    wayland-protocols
    zlib
  ];

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

  meta = with lib; {
    description = "Open source XR runtime";
    homepage = "https://monado.freedesktop.org/";
    license = licenses.boost;
    maintainers = with maintainers; [ expipiplus1 prusnak ];
    platforms = platforms.linux;
  };
}
