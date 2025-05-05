{
  lib,
  buildGoModule,
  fetchFromGitHub,

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
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "fyne-io";
    repo = "fyne";
    tag = "v${version}";
    hash = "sha256-e3UHOAtafOn1Nxfnjut04uKK3S/gv/08qAiGEW8r5Tc=";
  };

  vendorHash = "sha256-3lXDkiQoq+rDUN8Am9Bd/DJ5CKQqfQucbHKQrkS4wIg=";

  nativeBuildInputs = [ pkg-config ];

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
    description = "Cross platform GUI toolkit in Go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ greg ];
    mainProgram = "fyne";
  };
}
