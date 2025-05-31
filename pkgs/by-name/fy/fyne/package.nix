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
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "fyne-io";
    repo = "fyne";
    tag = "v${version}";
    hash = "sha256-ONtZd+WlgDUS4XwSvIDkCazPsmiTIXdaQua6fnq5NKQ=";
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
