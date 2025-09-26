{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hidapi,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnitrokey";
  version = "3.8";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "libnitrokey";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4PEZ31QyVOmdhpKqTN8fwcHoLuu+w+OJ3fZeqwlE+io=";
    # On OSX, libnitrokey depends on a custom version of hidapi in a submodule.
    # Monitor https://github.com/Nitrokey/libnitrokey/issues/140 to see if we
    # can remove this extra work one day.
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DADD_GIT_INFO=OFF"
    "-DCMAKE_INSTALL_UDEVRULESDIR=etc/udev/rules.d"
  ];

  buildInputs = [ libusb1 ];

  propagatedBuildInputs = [ hidapi ];

  doInstallCheck = true;

  meta = with lib; {
    description = "Communicate with Nitrokey devices in a clean and easy manner";
    homepage = "https://github.com/Nitrokey/libnitrokey";
    license = licenses.lgpl3;
    maintainers = with maintainers; [
      panicgh
      raitobezarius
    ];
  };
})
