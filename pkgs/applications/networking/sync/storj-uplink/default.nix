{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.92.1";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-yeKI8vOuYFhABz09awPuCmjrifLttvBq1kaxMf78/HI=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-odtCBLg04gG1ztyDLdBADhdEhMkrizNjOGymAtzXy9g=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
