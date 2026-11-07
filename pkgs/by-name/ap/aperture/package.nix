{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "aperture";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "aperture";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DgiNjGUdd2kPaJRY/eDM76Ut7kRGxxK5mP3VzLC9YEg=";
  };

  vendorHash = "sha256-b6cu9kf9z+rBcZ4XTzdqHpsI6tvxyhEe/E5AGPg0Tko=";

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
