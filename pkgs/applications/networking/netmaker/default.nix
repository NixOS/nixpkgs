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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netmaker";
    rev = "v${version}";
    hash = "sha256-acsIe3N6F76KktfPOHreFwDatyuv1q7ui6MMhVXfj7c=";
  };

  vendorHash = "sha256-Ur8cuE0jToOme79BTaYbaLDl2cRMjsr1DTvZjm8zmtc=";

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
