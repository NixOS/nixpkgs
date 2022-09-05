{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "rtl-sdr";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "librtlsdr";
    repo = "librtlsdr";
    rev = "v${version}";
    sha256 = "1fgxlkgmdchbrf0nn98ivjr6css5hak3608nr4xrf2qzf7xy2kdk";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '/etc/udev/rules.d' "$out/etc/udev/rules.d"

    substituteInPlace rtl-sdr.rules \
      --replace 'MODE:="0666"' 'ENV{ID_SOFTWARE_RADIO}="1", MODE="0660", GROUP="plugdev"'
  '';

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [ libusb1 ];

  cmakeFlags = lib.optional stdenv.isLinux [
    "-DINSTALL_UDEV_RULES=ON"
    "-DWITH_RPC=ON"
  ];

  meta = with lib; {
    description = "Turns your Realtek RTL2832 based DVB dongle into a SDR receiver";
    homepage = "https://github.com/librtlsdr/librtlsdr";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
