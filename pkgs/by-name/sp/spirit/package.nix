{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule {
  pname = "spirit";
  version = "0-unstable-2024-05-24";

  src = fetchFromGitHub {
    owner = "cashapp";
    repo = "spirit";
    rev = "a384d903db9586d2610f06319bd67814dad678a5";
    hash = "sha256-oybvdVSG9XvBk4j+a+R8CIrEmzZ+gV0Chysq/sr2sws=";
  };

  vendorHash = "sha256-iTU45Ce5Mb09MyJTzqueyO0F9wV39l106Lkj50oYDvc=";

  subPackages = [ "cmd/spirit" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/cashapp/spirit";
    description = "Online schema change tool for MySQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "spirit";
  };
}
