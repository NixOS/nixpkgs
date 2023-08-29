{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.86.2";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-peWcgME+OCa9feNKLtTmZIGCpNxl+EdQfYDXV2BbclI=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-sBez/IQzRIGQdOXr4Ikxh+dT8IQxtbxau5vo9VqGJvE=";

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
