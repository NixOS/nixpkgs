{ stdenv, fetchgit, cmake, pkgconfig, libusb1 }:

stdenv.mkDerivation rec {
  name = "rtl-sdr-${version}";
  version = "0.5.3";

  src = fetchgit {
    url = "git://git.osmocom.org/rtl-sdr.git";
    rev = "refs/tags/v${version}";
    sha256 = "1dh52xcvxkjb3mj80wlm20grz8cqf5wipx2ksi91ascz12b5pym6";
  };

  buildInputs = [ cmake pkgconfig libusb1 ];

  # TODO: get these fixes upstream:
  # * Building with -DINSTALL_UDEV_RULES=ON tries to install udev rules to
  #   /etc/udev/rules.d/, and there is no option to install elsewhere. So install
  #   rules manually.
  # * Propagate libusb-1.0 dependency in pkg-config file.
  postInstall = ''
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
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
