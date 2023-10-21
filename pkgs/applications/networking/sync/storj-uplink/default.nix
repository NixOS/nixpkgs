{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.90.1";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-LJtNsemNbN+TLyUxSgB/wftKxOfI/y/t+qv1TjcsXzQ=";
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
