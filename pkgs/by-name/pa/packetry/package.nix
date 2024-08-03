{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libusb1,
  glib,
  gdk-pixbuf,
  cairo,
  pango,
  gtk4,
  graphene,
}:

rustPlatform.buildRustPackage rec {
  pname = "packetry";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GmEv7wkYpSM3ds5AHGa+1IiuAdI2O793d+VtSU9vqag=";
  };

  cargoHash = "sha256-SxJIpK6Vzgl7QEGnnUOn4ejroPHWKieLRLMpLscEhs4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libusb1
    glib
    gdk-pixbuf
    cairo
    pango
    gtk4
    graphene
  ];

  doCheck = false;

  meta = with lib; {
    description = "A fast, intuitive USB 2.0 protocol analysis application for use with Cynthion.";
    homepage = "https://github.com/greatscottgadgets/packetry";
    license = licenses.bsd3;
    maintainers = with maintainers; [ carlossless ];
  };
}
