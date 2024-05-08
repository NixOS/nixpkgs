{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.102.4";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-ryOWnVcJOUs9kToXtwjUTk7nwuAW0NCDn5Npn27hKXU=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-atIb/SmOShLIhvEsTcegX7+xoDXN+SI5a7TQrXpqdUg=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
