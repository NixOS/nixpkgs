{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  udev,
  libevdev,
  libconfig,
}:

stdenv.mkDerivation rec {
  pname = "logiops";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "pixlone";
    repo = "logiops";
    rev = "v${version}";
    hash = "sha256-1v728hbIM2ODtB+r6SYzItczRJCsbuTvhYD2OUM1+/E=";
  };

<<<<<<< HEAD
  env.PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
=======
  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    udev
    libevdev
    libconfig
  ];

<<<<<<< HEAD
  meta = {
    description = "Unofficial userspace driver for HID++ Logitech devices";
    mainProgram = "logid";
    homepage = "https://github.com/PixlOne/logiops";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
=======
  meta = with lib; {
    description = "Unofficial userspace driver for HID++ Logitech devices";
    mainProgram = "logid";
    homepage = "https://github.com/PixlOne/logiops";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = with platforms; linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
