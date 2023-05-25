{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pachyderm";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "pachyderm";
    repo = "pachyderm";
    rev = "v${version}";
    hash = "sha256-QWlNDnhcFXfCtX4J0V/hq6nFN0RjzYv29mI2zE2fyFo=";
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
