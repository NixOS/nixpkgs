{ stdenv, fetchgit, cmake, pkgconfig, libusb1 }:

stdenv.mkDerivation rec {
  name = "rtl-sdr-${version}";
  version = "0.5.3-git";

  src = fetchgit {
    url = "git://git.osmocom.org/rtl-sdr.git";
    rev = "b04c2f9f035c5aede43d731e5d58e4725d2f8bb4";
    sha256 = "1w71z74czp0a3655iv38zrhsh0l897rdsmisx6iii1rix2dswk57";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake libusb1 ];

  # TODO: get these fixes upstream:
  # * Building with -DINSTALL_UDEV_RULES=ON tries to install udev rules to
  #   /etc/udev/rules.d/, and there is no option to install elsewhere. So install
  #   rules manually.
  # * Propagate libusb-1.0 dependency in pkg-config file.
  postInstall = stdenv.lib.optionalString stdenv.isLinux ''
    mkdir -p "$out/etc/udev/rules.d/"
    cp ../rtl-sdr.rules "$out/etc/udev/rules.d/99-rtl-sdr.rules"

    pcfile="$out"/lib/pkgconfig/librtlsdr.pc
    grep -q "Requires:" "$pcfile" && { echo "Upstream has added 'Requires:' in $(basename "$pcfile"); update nix expression."; exit 1; }
    echo "Requires: libusb-1.0" >> "$pcfile"
  '';

  meta = with stdenv.lib; {
    description = "Turns your Realtek RTL2832 based DVB dongle into a SDR receiver";
    homepage = http://sdr.osmocom.org/trac/wiki/rtl-sdr;
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
