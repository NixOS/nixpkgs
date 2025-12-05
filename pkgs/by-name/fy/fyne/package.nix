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
  # This is the current latest version
  # version "1.26.1" was a typo of "1.7.0" - maybe, don't "upgrade" to it
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "fyne-io";
    repo = "tools";
    rev = "v${version}";
    hash = "sha256-x2OfiFn5VHE3OrlfSMUQY1mckdnCcDpq1vqLmRi6yAg=";
  };

  vendorHash = "sha256-J5JxKN0i5nbLTBgwZ5HJPFiqHd7yvP+YkyvPteD2xF0=";

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
