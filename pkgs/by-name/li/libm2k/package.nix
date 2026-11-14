{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libiio,
  libad9361,
  libusb1,
  libxml2,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "libm2k";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "libm2k";
    tag = "v${version}";
    hash = "sha256-3R0/tah7d3mfZc0NhAWHF4t1lejD2vMWj3kjMcWq2xk=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libiio
    libad9361
    libusb1
    libxml2
  ];

  cmakeFlags = [
    "-DENABLE_PYTHON=OFF"
    "-DENABLE_CSHARP=OFF"
    "-DBUILD_EXAMPLES=OFF"
    "-DENABLE_TOOLS=on"
    "-DINSTALL_UDEV_RULES=ON"
    "-DUDEV_RULES_PATH=${placeholder "out"}/lib/udev/rules.d"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++ library for interfacing with the ADALM2000";
    homepage = "https://github.com/analogdevicesinc/libm2k";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ imadnyc ];
    platforms = lib.platforms.linux;
  };
}
