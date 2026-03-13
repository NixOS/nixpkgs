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
  libxrandr,
  libxi,
  libxinerama,
  libxcursor,
  libx11,
}:

buildGoModule rec {
  pname = "netmaker";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netmaker";
    rev = "v${version}";
    hash = "sha256-MByCHcXd4gMsUVzBGdnPjH7MrFqpX7Hfmj6VYWneC0Q=";
  };

  vendorHash = "sha256-EIXhKkAYYx0GPV7DjbVXSF4Ps+2kHOBqGeNNKvCZGo0=";

  inherit subPackages;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libglvnd
    libx11
    libxcursor
    libxi
    libxinerama
    libxrandr
  ];

  meta = {
    description = "WireGuard automation from homelab to enterprise";
    homepage = "https://netmaker.io";
    changelog = "https://github.com/gravitl/netmaker/-/releases/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      qjoly
    ];
    mainProgram = "netmaker";
  };
}
