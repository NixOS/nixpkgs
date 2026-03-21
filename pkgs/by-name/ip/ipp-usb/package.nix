{
  buildGoModule,
  avahi,
  libusb1,
  pkg-config,
  lib,
  fetchFromGitHub,
  ronn,
}:
buildGoModule (finalAttrs: {
  pname = "ipp-usb";
  version = "0.9.31";

  src = fetchFromGitHub {
    owner = "openprinting";
    repo = "ipp-usb";
    rev = finalAttrs.version;
    sha256 = "sha256-WoJa00dSTXknoEjRO/L1yZc6pA0SfAhKsG6QqS6aDSc=";
  };

  postPatch = ''
    # rebuild with patched paths
    rm ipp-usb.8
    substituteInPlace Makefile \
      --replace-fail "install: all" "install: man" \
      --replace-fail "/usr/" "/"
    substituteInPlace systemd-udev/ipp-usb.service --replace-fail "/sbin" "$out/bin"
    for i in paths.go ipp-usb.8.md; do
      substituteInPlace $i --replace-fail "/usr" "$out"
      substituteInPlace $i --replace-fail "/var/ipp-usb" "/var/lib/ipp-usb"
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

  doInstallCheck = true;

  postInstall = ''
    # to accommodate the makefile
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
})
