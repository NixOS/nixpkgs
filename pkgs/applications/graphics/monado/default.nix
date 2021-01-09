{ stdenv
, fetchFromGitLab
, fetchpatch
, cmake
, pkg-config
, python3
, SDL2
, dbus
, eigen
, ffmpeg
, glslang
, hidapi
, libGL
, libXau
, libXdmcp
, libXrandr
, libffi
# , librealsense
, libsurvive
, libusb1
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
}:

stdenv.mkDerivation rec {
  pname = "monado";
  version = "0.4.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "114aif79dqyn2qg07mkv6lzmqn15k6fdcii818rdf5g4bp7zzzgm";
  };

  patches = [
    # fix libsurvive autodetection, drop with the next version update
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/monado/monado/-/commit/345e9eab56e2de9e8b07cf72c2a67cf2ebd01e62.patch";
      sha256 = "17c110an6sxc8rn7dfz30rfkbayg64w68licicwc8cqabi6cgrm3";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config python3 ];

  buildInputs = [
    SDL2
    dbus
    eigen
    ffmpeg
    glslang
    hidapi
    libGL
    libXau
    libXdmcp
    libXrandr
    libffi
    # librealsense.dev - see below
    libsurvive
    libusb1
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

  meta = with stdenv.lib; {
    description = "Open source XR runtime";
    homepage = "https://monado.freedesktop.org/";
    license = licenses.boost;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.linux;
  };
}
