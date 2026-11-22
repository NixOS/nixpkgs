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
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netmaker";
    rev = "v${version}";
    hash = "sha256-buPgYC9556KkdWC3pwyN5Mf9wJrYaJYwyuyeg9bvE94=";
  };

  vendorHash = "sha256-9pWcY4PaLLwFD0dg5Rn8c20yc3EucRvjin6zVdELn8A=";

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
