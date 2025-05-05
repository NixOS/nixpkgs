{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "e1s";
  version = "1.0.46";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "keidarcy";
    repo = "e1s";
    tag = "v${version}";
    hash = "sha256-Wnj6HNxVdhnmGMtw+Da/LRxMkXBm+rWDUcHPOxFXDLU=";
  };

  vendorHash = "sha256-bBl4D7HNIiAym6BWSJ0x4LZnIEUMfECj6dDDVZIFrHA=";

  meta = with lib; {
    description = "Easily Manage AWS ECS Resources in Terminal 🐱";
    homepage = "https://github.com/keidarcy/e1s";
    changelog = "https://github.com/keidarcy/e1s/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "e1s";
    maintainers = with maintainers; [
      zelkourban
      carlossless
    ];
  };
}
