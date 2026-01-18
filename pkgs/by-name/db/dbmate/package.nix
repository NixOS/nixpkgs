{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dbmate";
  version = "2.29.3";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    tag = "v${version}";
    hash = "sha256-H/HBDM2uBRrlgetU2S9ZS1c6//Le+DlrYlnnJpTs3XM=";
  };


  doCheck = false;
  vendorHash = "sha256-wfcVb8fqnpT8smKuL6SPANAK86tLXglhQPZCA4G8P9E=";

  meta = {
    description = "Database migration tool";
    mainProgram = "dbmate";
    homepage = "https://github.com/amacneil/dbmate";
    changelog = "https://github.com/amacneil/dbmate/releases/tag/v${version}";
    license = lib.licenses.mit;
  };
}
