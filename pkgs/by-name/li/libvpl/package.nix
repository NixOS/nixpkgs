{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, substituteAll
, addDriverRunpath
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvpl";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "libvpl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2yfJo4iwI/h0CJ+mJJ3cAyG5S7KksUibwJHebF3MR+E=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DENABLE_DRI3=ON"
      "-DENABLE_DRM=ON"
      "-DENABLE_VA=ON"
      "-DENABLE_WAYLAND=ON"
      "-DENABLE_X11=ON"
      "-DINSTALL_EXAMPLE_CODE=OFF"
      "-DBUILD_TOOLS=OFF"
  ];

  patches = [
    (substituteAll {
      src = ./opengl-driver-lib.patch;
      inherit (addDriverRunpath) driverLink;
    })
  ];

  meta = with lib; {
    description = "Intel Video Processing Library";
    homepage = "https://intel.github.io/libvpl/";
    license = licenses.mit;
    platforms = platforms.linux;
  };
})
