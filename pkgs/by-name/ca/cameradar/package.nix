{
  lib,
  buildGoModule,
  curl,
  fetchFromGitHub,
  pkg-config,
}:

buildGoModule (finalAttrs: {
  pname = "cameradar";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "Ullaakut";
    repo = "cameradar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NgzTZpRrFLoFNn3xiR5ysORTO9Yj2kn2aPSwSa441t0=";
  };

  vendorHash = "sha256-NljQGN/B/+gdMGmE1pI2rJPfZNY3xBHYLf+xPxzuh3w=";

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
