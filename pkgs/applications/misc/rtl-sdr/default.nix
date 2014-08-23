{ stdenv, fetchgit, cmake, pkgconfig, libusb1 }:

stdenv.mkDerivation rec {
  name = "rtl-sdr-${version}";
  version = "0.5.3";

  src = fetchgit {
    url = "git://git.osmocom.org/rtl-sdr.git";
    rev = "refs/tags/v${version}";
    sha256 = "00r5d08r12zzkd0xggd7l7p4r2278rzdhqdaihwjlajmr9qd3hs1";
  };

  buildInputs = [ cmake pkgconfig libusb1 ];

  # Building with -DINSTALL_UDEV_RULES=ON tries to install udev rules to
  # /etc/udev/rules.d/, and there is no option to install elsewhere. So install
  # rules manually.
  postInstall = ''
    mkdir -p "$out/etc/udev/rules.d/"
    cp ../rtl-sdr.rules "$out/etc/udev/rules.d/99-rtl-sdr.rules"
  '';

  meta = with stdenv.lib; {
    description = "Turns your Realtek RTL2832 based DVB dongle into a SDR receiver";
    homepage = http://sdr.osmocom.org/trac/wiki/rtl-sdr;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
