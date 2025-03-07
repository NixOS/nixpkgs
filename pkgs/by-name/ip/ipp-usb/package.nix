{
  buildGoModule,
  avahi,
  libusb1,
  pkg-config,
  lib,
  fetchFromGitHub,
  ronn,
}:
buildGoModule rec {
  pname = "ipp-usb";
  version = "0.9.28";

  src = fetchFromGitHub {
    owner = "openprinting";
    repo = "ipp-usb";
    rev = version;
    sha256 = "sha256-fjhiOftiZmc9/mA/0yQuIF4/OsBuGUIpf7DLrJB3GRk=";
  };

  postPatch = ''
    # rebuild with patched paths
    rm ipp-usb.8
    substituteInPlace Makefile --replace "install: all" "install: man"
    substituteInPlace systemd-udev/ipp-usb.service --replace "/sbin" "$out/bin"
    for i in Makefile paths.go ipp-usb.8.md; do
      substituteInPlace $i --replace "/usr" "$out"
      substituteInPlace $i --replace "/var/ipp-usb" "/var/lib/ipp-usb"
    done
  '';

  nativeBuildInputs = [
    pkg-config
    ronn
  ];
  buildInputs = [
    libusb1
    avahi
  ];

  vendorHash = null;

  postInstall = ''
    # to accomodate the makefile
    cp $out/bin/ipp-usb .
    make install DESTDIR=$out
  '';

  meta = {
    description = "Daemon to use the IPP everywhere protocol with USB printers";
    mainProgram = "ipp-usb";
    homepage = "https://github.com/OpenPrinting/ipp-usb";
    maintainers = [ lib.maintainers.symphorien ];
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd2;
  };
}
