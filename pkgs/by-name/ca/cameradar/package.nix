{
  lib,
  buildGoModule,
  curl,
  fetchFromGitHub,
  pkg-config,
}:

buildGoModule (finalAttrs: {
  pname = "cameradar";
  version = "6.2.1";

  src = fetchFromGitHub {
    owner = "Ullaakut";
    repo = "cameradar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t6xB5llBouAJqhrRDXlvyeplsq3wUKnOBbNj/TSbP0I=";
  };

  vendorHash = "sha256-f5N0Vu0cy9Eoxhp487unP8sVwuFRGEi5GFTQmkdoDxI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ curl ];

  subPackages = [ "cmd/cameradar" ];

  meta = {
    description = "RTSP stream access tool";
    homepage = "https://github.com/Ullaakut/cameradar";
    changelog = "https://github.com/Ullaakut/cameradar/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
