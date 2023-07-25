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
  version = "0.20.4";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4njC4hQoiAWlkwyvP14wWK+PxQ6bGR5QzteurHcuo4o=";
  };

  vendorHash = "sha256-f6foYD/2b9iLzQbPTXeiKCdrm7gz5E8ulWHZaj+KB/M=";

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
    license = licenses.sspl;
    maintainers = with maintainers; [ urandom ];
  };
}
