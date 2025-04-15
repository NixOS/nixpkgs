{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.126.2";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-dt4OzkblMxduZJZhUHWzYGrOLs+rzI3JXa16SlRs3MI=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-1TZmG008XhA9lt4Vj7jdF0wyDFQ65hql0r+kU+RAx78=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
