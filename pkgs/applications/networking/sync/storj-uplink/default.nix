{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.90.2";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-VEO9LV6hzEd4IDnSPE5H0CDlwgRFEg4cheDx/RUGQug=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-R713WhFrWT7Cgstk3SLuvvyk3/ZtT1LOH0qqmFcWzKw=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
