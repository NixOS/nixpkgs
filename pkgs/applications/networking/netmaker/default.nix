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
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0KyBRIMXGqg4MdTyN3Kw1rVbZ7ULlfW6M9DSfAUQF8A=";
  };

  vendorHash = "sha256-B9r+p9kL/8h5qGmJ2WChnU3qKFf9z76YFqn6M2dXsDg=";

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
