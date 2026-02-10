{
  lib,
  buildGoModule,
  curl,
  fetchFromGitHub,
  pkg-config,
}:

buildGoModule (finalAttrs: {
  pname = "cameradar";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "Ullaakut";
    repo = "cameradar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XmCpd7ptPU26EMn+WDH2Y9hKRsYV0GdbU4T26TUsp6U=";
  };

  vendorHash = "sha256-A8SJRky4dQHJoYpOaUBae89kHXwbdA+gnF/p7oRxcYo=";

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
