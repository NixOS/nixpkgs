{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "writefreely";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "writefreely";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Qr31XSbAckLElD81yxD+K7tngWECQ+wyuESC+biAbyw=";
  };

  vendorHash = "sha256-HmEh8WmKbdAimvzsAiaXcqSXoU1DJx06+s1EH1JZmwo=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/writefreely/writefreely.softwareVer=${version}"
  ];

  tags = [ "sqlite" ];

  subPackages = [ "cmd/writefreely" ];

  passthru.tests = {
    inherit (nixosTests) writefreely;
  };

  meta = with lib; {
    description = "Build a digital writing community";
    homepage = "https://github.com/writefreely/writefreely";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ soopyc ];
    mainProgram = "writefreely";
  };
}
