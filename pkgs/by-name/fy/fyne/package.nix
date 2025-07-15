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
  version = "1.26.1";

  src = fetchFromGitHub {
    owner = "fyne-io";
    repo = "tools";
    rev = "v${version}";
    hash = "sha256-eBwbXyhI1s4se7krzTemoSehgSXN7mht70q8mk+yGoM=";
  };

  vendorHash = "sha256-7B0PCKMfLULmqzIlNFeXhOUThnWSe9+gRhpswbiwLP4=";

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
