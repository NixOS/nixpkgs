{
  lib,
  buildGoModule,
  fetchFromGitea,
}:

buildGoModule {
  pname = "file-compose";
  version = "0-unstable-2023-10-21";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "readeck";
    repo = "file-compose";
    rev = "afa938655d412556a0db74b202f9bcc1c40d8579";
    hash = "sha256-rMANRqUQRQ8ahlxuH1sWjlGpNvbReBOXIkmBim/wU2o=";
  };

  vendorHash = "sha256-Qwixx3Evbf+53OFeS3Zr7QCkRMfgqc9hUA4eqEBaY0c=";

  meta = {
    description = "Simple tool and go library to perform content composition with YAML and JSON files";
    homepage = "https://codeberg.org/readeck/file-compose";
    license = lib.licenses.agpl3Only;
    mainProgram = "file-compose";
    maintainers = with lib.maintainers; [ ];
  };
}
