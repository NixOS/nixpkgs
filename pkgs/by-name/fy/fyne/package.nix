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
  # version "1.26.1" was a typo of "1.6.2" - maybe, don't "upgrade" to it
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "fyne-io";
    repo = "tools";
    rev = "v${version}";
    hash = "sha256-N5v1oytSwRHE631KQDHTulUAqs/Jlr8YJqE8wy+Ygdk=";
  };

  vendorHash = "sha256-LU3UkWHsf0Qt6w5tNIz11ubI+OIWkbtqqSlcoYJVFZU=";

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
