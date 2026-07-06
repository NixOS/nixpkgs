{
  lib,
  buildGoModule,
  curl,
  fetchFromGitHub,
  pkg-config,
}:

buildGoModule (finalAttrs: {
  pname = "cameradar";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "Ullaakut";
    repo = "cameradar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wJiHCJHG8S+iGFd9jFyavyxAtJ5FGlbvfFcGQfwpi9Y=";
  };

  vendorHash = "sha256-1jqGRwgbfcOq6fE3h9RJSeLRlFkd4w4L/2RwscA0zZ0=";

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
