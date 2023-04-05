{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pachyderm";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "pachyderm";
    repo = "pachyderm";
    rev = "v${version}";
    hash = "sha256-COtOYR1toSr+oiRZ5Hfbgfy2InF9jFThT0ozwrcSVio=";
  };

  vendorHash = "sha256-XmIPifozTYd1rV2wm0dU0GPvg/+HFoSLGHB6DDrkzVc=";

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
