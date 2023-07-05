{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pachyderm";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "pachyderm";
    repo = "pachyderm";
    rev = "v${version}";
    hash = "sha256-V8N7KaNlpDTOmUdfx3otC7ady57lkXHFcZ1LO8VMnFU=";
  };

  vendorHash = "sha256-3EG9d4ERaWuHaKFt0KFCOKIgTdrL7HZTO+GSi2RROKY=";

  subPackages = [ "src/server/cmd/pachctl" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pachyderm/pachyderm/v${lib.versions.major version}/src/version.AppVersion=${version}"
  ];

  meta = with lib; {
    description = "Containerized Data Analytics";
    homepage = "https://www.pachyderm.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ offline ];
    mainProgram = "pachctl";
  };
}
