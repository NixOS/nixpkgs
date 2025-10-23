{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libXi,
  libXrandr,
  libXt,
  libXtst,
}:

buildGoModule rec {
  pname = "remote-touchpad";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "unrud";
    repo = "remote-touchpad";
    rev = "v${version}";
    sha256 = "sha256-mIPBUREv2uIiIiucPyKLBmf8OJPVPsbc8QI9v3NTBIQ=";
  };

  buildInputs = [
    libXi
    libXrandr
    libXt
    libXtst
  ];
  tags = [ "portal,x11" ];

  vendorHash = "sha256-d2kKF13ESntZ0pRTYs5eFpkCTuOhei/bTyTmdYWvvRY=";

  meta = with lib; {
    description = "Control mouse and keyboard from the web browser of a smartphone";
    mainProgram = "remote-touchpad";
    homepage = "https://github.com/unrud/remote-touchpad";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
    platforms = platforms.linux;
  };
}
