{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dbmate";
  version = "2.23.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "refs/tags/v${version}";
    hash = "sha256-xmQS0eBOgll8+AU/kQriClqtwrfIz606/o7jEJlQLV8=";
  };

  vendorHash = "sha256-xJIY0vaN7gw/EhqeepKQPhaKISXNNPnaAMbowmHSUz4=";

  doCheck = false;

  meta = with lib; {
    description = "Database migration tool";
    mainProgram = "dbmate";
    homepage = "https://github.com/amacneil/dbmate";
    changelog = "https://github.com/amacneil/dbmate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ manveru ];
  };
}
