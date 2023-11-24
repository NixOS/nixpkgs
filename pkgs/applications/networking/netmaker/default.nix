{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
, libglvnd
, pkg-config
, subPackages ? ["." "netclient"]
, xorg
}:

buildGoModule rec {
  pname = "netmaker";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LfvO95jqzJzB44JxzB00GubTKJkvK/NR42eGYipirbM=";
  };

  vendorHash = "sha256-BRgzPH7uiUHcouEw0KNpM5k0/kZMImvI9MFn4ahXIRM=";

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

  meta = with lib; {
    description = "WireGuard automation from homelab to enterprise";
    homepage = "https://netmaker.io";
    changelog = "https://github.com/gravitl/netmaker/-/releases/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom qjoly ];
  };
}
