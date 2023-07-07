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
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oxXGNmec5s4yN2SAjAUrvF2gJ9XkafwK98kDroIIssQ=";
  };

  vendorHash = "sha256-p/MnieYNLq+mleqhqCYL9PBV2dVm+Zs945RwbdKjrus=";

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
