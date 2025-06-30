{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "aperture";
  version = "0.3-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "aperture";
    tag = "v${version}";
    hash = "sha256-PsmaNJxWkXiFDA7IGhT+Kx1GUvv23c8L8Jz21/b48oo=";
  };

  vendorHash = "sha256-rrDLdE7c6ykhdqOfRpuxyRO4xqYp3LZvovAppzy1wVw=";

  subPackages = [ "cmd/aperture" ];

  meta = {
    description = "L402 (Lightning HTTP 402) Reverse Proxy";
    homepage = "https://github.com/lightninglabs/aperture";
    changelog = "https://github.com/lightninglabs/aperture/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sputn1ck
      HannahMR
    ];
    mainProgram = "aperture";
  };
}
