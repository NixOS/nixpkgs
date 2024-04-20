{
  lib,
  buildGoModule,
  fetchFromGitHub,

  dbus,
  libGL,
  libX11,
  libXcursor,
  libXinerama,
  libXi,
  libXrandr,
  libXxf86vm,
  pkg-config,
}:

buildGoModule rec {
  pname = "fyne";
  version = "2.4.5";

  src = fetchFromGitHub {
    owner = "fyne-io";
    repo = "fyne";
    rev = "v${version}";
    hash = "sha256-vOkXJ0vsyBUPDMA0gAnmnDAfi6a02sEBDXTzt6muYgo=";
  };

  vendorHash = "sha256-T/ckbptaxxFNwhRkDPwWLg9W5b8Yp4cJ7UZuStdCsJ0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libGL
    libX11
    libXcursor
    libXinerama
    libXi
    libXrandr
    libXxf86vm
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://fyne.io";
    description = "A GUI library and tools for golang";
    license = licenses.bsd3;
    maintainers = [ maintainers.greg ];
    mainProgram = "fyne";
  };
}
