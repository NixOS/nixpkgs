{
  lib,
  buildGoModule,
  curl,
  fetchFromGitHub,
  pkg-config,
}:

buildGoModule rec {
  pname = "cameradar";
  version = "5.0.4";

  src = fetchFromGitHub {
    owner = "Ullaakut";
    repo = "cameradar";
    tag = "v${version}";
    hash = "sha256-nfqgBUgcLjPLdn8hs1q0FLDBHbloeMKETDrv3a5SZq0=";
  };

  vendorHash = "sha256-AIi57DWMvAKl0PhuwHO/0cHoDKk5e0bJsqHYBka4NiU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ curl ];

  subPackages = [ "cmd/cameradar" ];

  meta = {
    description = "RTSP stream access tool";
    homepage = "https://github.com/Ullaakut/cameradar";
    changelog = "https://github.com/Ullaakut/cameradar/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
