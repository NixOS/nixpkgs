{ lib
, stdenv
, fetchgit
, cmake
, pkg-config
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "rtl-sdr";
  version = "0.6.0";

  src = fetchgit {
    url = "git://git.osmocom.org/rtl-sdr.git";
    rev = "refs/tags/${version}";
    sha256 = "0lmvsnb4xw4hmz6zs0z5ilsah5hjz29g1s0050n59fllskqr3b8k";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '/etc/udev/rules.d' "$out/etc/udev/rules.d"

    substituteInPlace rtl-sdr.rules \
      --replace 'MODE:="0666"' 'ENV{ID_SOFTWARE_RADIO}="1", MODE="0660", GROUP="plugdev"'
  '';

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [ libusb1 ];

  cmakeFlags = lib.optional stdenv.isLinux "-DINSTALL_UDEV_RULES=ON";

  meta = with lib; {
    description = "Turns your Realtek RTL2832 based DVB dongle into a SDR receiver";
    homepage = "http://github.com/librtlsdr/librtlsdr";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
