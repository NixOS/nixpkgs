{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "fingerprintx";
  version = "1.1.19";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "fingerprintx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aK3XYSbFd1FfgbORUQn9ogOD4HZC5Ig/fz7nHYcW09s=";
  };

  vendorHash = "sha256-kAAg0zrVfFcbk1HXwUrUI380Sf//vAhGa6HdJlPgn90=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Standalone utility for service discovery on open ports";
    mainProgram = "fingerprintx";
    homepage = "https://github.com/praetorian-inc/fingerprintx";
    changelog = "https://github.com/praetorian-inc/fingerprintx/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
