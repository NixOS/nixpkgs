{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvpl";
  version = "2023.4.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-K2TWk6e0qzxfHWk1eFynCPGleWU0vll6y6Ah4/BOTRw=";
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

  meta = with lib; {
    description = "Intel Video Processing Library";
    homepage = "https://intel.github.io/libvpl/";
    license = licenses.mit;
    platforms = platforms.linux;
  };
})
