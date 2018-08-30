{ stdenv, lib, fetchpatch, fetchgit, cmake, pkgconfig, libusb1 }:

stdenv.mkDerivation rec {
  name = "rtl-sdr-${version}";
  version = "0.5.4";

  src = fetchgit {
    url = "git://git.osmocom.org/rtl-sdr.git";
    rev = "refs/tags/v${version}";
    sha256 = "0c56a9dhlqgs6y15ns0mn4r5giz0x6y7x151jcq755f711pc3y01";
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
  patches = lib.optionals stdenv.isDarwin [
    (fetchpatch {
      name = "linker-fix.patch";
      url = "https://github.com/lukeadams/rtl-sdr/commit/7a66dcf268305b5aa507d1756799942c74549b72.patch";
      sha256 = "0cn9fyf4ay4i3shvxj1ivgyxjvfm401irk560jdjl594nzadrcsl";
    })
  ];
  meta = with stdenv.lib; {
    description = "Turns your Realtek RTL2832 based DVB dongle into a SDR receiver";
    homepage = http://sdr.osmocom.org/trac/wiki/rtl-sdr;
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
