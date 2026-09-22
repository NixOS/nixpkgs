{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "checkip";
  version = "0.54.0";

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = "checkip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O9+YR1EjTSABQdPJHPVTPnD4MAxFpa00Uq0fHV2OsE4=";
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
