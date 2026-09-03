{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
}:

stdenv.mkDerivation {
  pname = "libuvc";
  version = "0.0.7-unstable-2024-03-05";

  src = fetchFromGitHub {
    owner = "libuvc";
    repo = "libuvc";
    rev = "047920bcdfb1dac42424c90de5cc77dfc9fba04d";
    hash = "sha256-Ds4N9ezdO44eBszushQVvK0SUVDwxGkUty386VGqbT0=";
  };

  # Upstream doesn't yet support CMake 4, remove once fixed
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1)" "cmake_minimum_required(VERSION 3.5)"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ libusb1 ];

  meta = {
    homepage = "https://ken.tossell.net/libuvc/";
    description = "Cross-platform library for USB video devices";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
