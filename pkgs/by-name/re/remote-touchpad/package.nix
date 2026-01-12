{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libxi,
  libxrandr,
  libXt,
  libxtst,
}:

buildGoModule rec {
  pname = "remote-touchpad";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "unrud";
    repo = "remote-touchpad";
    rev = "v${version}";
    sha256 = "sha256-9K/AdkfpQbXPDIwai3h98G4lo4p8c/yTLxirhbo03U4=";
  };

  buildInputs = [
    libxi
    libxrandr
    libXt
    libxtst
  ];
  tags = [ "portal,x11" ];

  vendorHash = "sha256-nkzvE59H7adyzveXYFI1NVwIh8chBRrVZZKfLY0fEaw=";

  meta = {
    description = "Control mouse and keyboard from the web browser of a smartphone";
    mainProgram = "remote-touchpad";
    homepage = "https://github.com/unrud/remote-touchpad";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ schnusch ];
    platforms = lib.platforms.linux;
  };
}
