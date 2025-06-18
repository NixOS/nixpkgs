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
  version = "0.90.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/7tj3SuTa2lSMgN4f2/OutzoPvAN7ARK1RKTLlMw13Y=";
  };

  vendorHash = "sha256-Yd9vwdIwAGinIr/RLGdb4N9hsDeMu9aB2Z1EVnlxxtA=";

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
