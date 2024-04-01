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
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-M2DY+C0g8G+DjicMeT3Ojn4GzG7vaE1OHKSy7O6T1Kk=";
  };

  vendorHash = "sha256-SUu0OvHCmlssH9HbAaMbiG0gF/ezxgf1n0HBiB/2PTs=";

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
    mainProgram = "netmaker";
  };
}
