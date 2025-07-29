{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libglvnd,
  pkg-config,
  subPackages ? [
    "."
    "netclient"
  ],
  xorg,
}:

buildGoModule rec {
  pname = "netmaker";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CaN6sTD34hHAMwW90Ofe76me/vaO5rz7IlqQzEhgXQc=";
  };

  vendorHash = "sha256-Eo+7L1LffJXzsBwTcOMry2ZWUHBepLOcLm4bmkNMmLY=";

  inherit subPackages;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libglvnd
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
  ];

  meta = {
    description = "WireGuard automation from homelab to enterprise";
    homepage = "https://netmaker.io";
    changelog = "https://github.com/gravitl/netmaker/-/releases/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      urandom
      qjoly
    ];
    mainProgram = "netmaker";
  };
}
