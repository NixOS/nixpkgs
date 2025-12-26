{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dbmate";
  version = "2.28.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    tag = "v${version}";
    hash = "sha256-DQTeLqlZmzfTQoJBTFTX8x3iplkmrl1cplDQQcCGCZM=";
  };

  vendorHash = "sha256-Js0hiRt6l3ur7+pfeYa35C17gr77NHvapaSrgF9cP8c=";

  doCheck = false;

  meta = {
    description = "Database migration tool";
    mainProgram = "dbmate";
    homepage = "https://github.com/amacneil/dbmate";
    changelog = "https://github.com/amacneil/dbmate/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ manveru ];
  };
}
