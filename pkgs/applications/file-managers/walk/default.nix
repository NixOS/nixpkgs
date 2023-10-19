{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "walk";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "walk";
    rev = "v${version}";
    hash = "sha256-Wo8i0nPAuzADLXlsEho9TSSbNh3d13iNsXXx5onPnIs=";
  };

  vendorHash = "sha256-AmgCyq+N+EMdpIUCe6Lzd8bDXHsbOzclsHPp+H5ROMc=";

  meta = with lib; {
    description = "Terminal file manager";
    homepage = "https://github.com/antonmedv/walk";
    license = licenses.mit;
    maintainers = with maintainers; [ portothree surfaceflinger ];
    mainProgram = "walk";
  };
}
