{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "checkip";
  version = "0.55.0";

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = "checkip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UPumm2ma+kiQkw8SKApreo415oJx2mkIT6/oUpj0s1A=";
  };

  vendorHash = "sha256-pQCftl9hmTRUNzGssWmUqIkL6WfJXE30BVzDAPmDxPY=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Requires network
  doCheck = false;

  meta = {
    description = "CLI tool that checks an IP address using various public services";
    homepage = "https://github.com/jreisinger/checkip";
    changelog = "https://github.com/jreisinger/checkip/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "checkip";
  };
})
