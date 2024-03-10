{ lib
, stdenv
, fetchFromGitHub
, udev
, cmake
, pkg-config
}:

stdenv.mkDerivation(finalAttrs: {
  pname = "libusbp";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "pololu";
    repo = "libusbp";
    rev = finalAttrs.version;
    hash = "sha256-60xpJ97GlqEcy2+pxGNGPfWDnbIFGoPXJijaErOBXQs=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  propagatedBuildInputs = [
    udev
  ];

  meta = with lib; {
    homepage = "https://github.com/pololu/libusbp";
    description = "Pololu USB Library (also known as libusbp)";
    longDescription = ''
      libusbp is a cross-platform C library for accessing USB devices
    '';
    platforms = platforms.all;
    license = licenses.cc-by-sa-30;
    maintainers = with maintainers; [ bzizou ];
  };
})
