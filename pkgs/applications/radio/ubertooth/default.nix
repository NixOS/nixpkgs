{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, libbtbb, libpcap , libusb1, bluez
, udevGroup ? "ubertooth"
}:

stdenv.mkDerivation rec {
  pname = "ubertooth";
  version = "2018-12-R1";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = pname;
    rev = version;
    sha256 = "1da5fsjwc5szclq6h5wznvgwikd1qqv8gbmv38h0fpc12lwn85c4";
  };

  sourceRoot = "source/host";

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libbtbb libpcap libusb1 bluez ];

  cmakeFlags = lib.optionals stdenv.isLinux [
    "-DINSTALL_UDEV_RULES=TRUE"
    "-DUDEV_RULES_PATH=etc/udev/rules.d"
    "-DUDEV_RULES_GROUP=${udevGroup}"
  ];

  meta = with stdenv.lib; {
    description = "Open source wireless development platform suitable for Bluetooth experimentation";
    homepage = "https://github.com/greatscottgadgets/ubertooth";
    license = licenses.gpl2;
    maintainers = with maintainers; [ oxzi ];
    platforms = platforms.linux;
  };
}
