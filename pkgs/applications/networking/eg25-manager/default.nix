{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, glib
, glibmm
, libgpiod
, libgudev
, libusb
}:

stdenv.mkDerivation rec {
  pname = "eg25-manager";
  version = "0.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    group = "mobian1";
    owner = "devices";
    repo = pname;
    rev = version;
    sha256 = "077i4z0w8589m5r0ffvwa13p7c1vvqdwcs2gkrlbx40yiv6x2wnr";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
    glibmm
    libgpiod
    libgudev
    libusb
  ];

  meta = with lib; {
    description = "Manager daemon for the Quectel EG25 mobile broadband modem";
    homepage = "https://gitlab.com/mobian1/devices/eg25-manager";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tomfitzhenry ];
    platforms = platforms.linux;
  };
}
