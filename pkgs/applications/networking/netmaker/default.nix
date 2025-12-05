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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netmaker";
    rev = "v${version}";
    hash = "sha256-MqRuiQsbdnjP2lXXbfvsQpnhEo411K4sgsjd4+uB2F8=";
  };

  vendorHash = "sha256-QR/bVGMmbx/dy1jYeKwmjqbFBHVCXrmFWnBaFoT0n1U=";

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
