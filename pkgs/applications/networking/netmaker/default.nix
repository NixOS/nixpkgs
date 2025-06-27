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
  version = "0.99.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DUD6JTnTM3QVLhWIoRZ0Jc+Jre8GXtuKkV6MzLYCg4U=";
  };

  vendorHash = "sha256-QD9jkpsANzJeFHd4miShgACNOvI6sy38fs7pZNkPhms=";

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
