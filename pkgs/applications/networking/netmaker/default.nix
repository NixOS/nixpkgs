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
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netmaker";
    rev = "v${version}";
    hash = "sha256-65yoTmja4tCPlA4Gy2s+kVVYJK5vtEvR8G/0tF8sxcU=";
  };

  vendorHash = "sha256-w8jrlcn/U7J90kmMaeH2/yTuJLo0dhvVC2iaFXRMYww=";

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
