{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "aperture";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "aperture";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XVLpIuBCavCbHcSMPFmxNxtdkr+jYy/AYjffzyKSYOg=";
  };

  vendorHash = "sha256-I7StCuL8UifVXBvchG0VRWA5nZc+nwIpK6+PQfkVGGo=";

  subPackages = [ "cmd/aperture" ];

  meta = {
    description = "L402 (Lightning HTTP 402) Reverse Proxy";
    homepage = "https://github.com/lightninglabs/aperture";
    changelog = "https://github.com/lightninglabs/aperture/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sputn1ck
      HannahMR
    ];
    mainProgram = "aperture";
  };
})
