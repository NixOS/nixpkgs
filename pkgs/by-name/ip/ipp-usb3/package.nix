{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libusb1,
  avahi,
}:

buildGoModule (finalAttrs: {
  pname = "ipp-usb";
  version = "0.9.34";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "ipp-usb";
    tag = "${finalAttrs.version}";
    hash = "sha256-4xZf8Q1MfQcB13vHRdb8dQyZWrwnJzubdi+zln1lRc8=";
  };

  __structuredAttrs = true;

  vendorHash = null;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libusb1
    avahi
  ];

  strictDeps = true;

  env.CGO_ENABLED = "1";

  postInstall = ''
    install -Dm444 ipp-usb.conf -t "$out/share/ipp-usb"
    install -Dm444 ipp-usb.8 -t "$out/share/man/man8"
    cp -r ipp-usb-quirks "$out/share/ipp-usb/quirks"

    install -Dm444 systemd-udev/*.rules -t "$out/lib/udev/rules.d"
    install -Dm444 systemd-udev/*.service -t "$out/lib/systemd/system"
  '';

  meta = {
    description = "HTTP reverse proxy exposing IPP-over-USB printers/scanners as local IPP/eSCL services";
    homepage = "https://github.com/OpenPrinting/ipp-usb";
    license = lib.licenses.bsd2;
    mainProgram = "ipp-usb";
    maintainers = with lib.maintainers; [
      nick-linux
    ];
    platforms = lib.platforms.linux;
  };
})
