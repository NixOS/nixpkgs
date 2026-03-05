{
  lib,
  buildGoModule,
  curl,
  fetchFromGitHub,
  pkg-config,
}:

buildGoModule (finalAttrs: {
  pname = "cameradar";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "Ullaakut";
    repo = "cameradar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C1GScKbOgHAU57B3q7A8Rv37Ny+7p+/L3ZwyiDN0kA0=";
  };

  vendorHash = "sha256-jIOQwVnlXbvzqGLPv/zTuSg5GaEWpmTyXEZO73jFGxM=";

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
