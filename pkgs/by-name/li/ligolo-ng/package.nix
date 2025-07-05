{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ligolo-ng";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "tnpitsecurity";
    repo = "ligolo-ng";
    tag = "v${version}";
    hash = "sha256-ND0SFB0xj4WK6okNzChZWfK5bhNc4PTWuZoq/PodTW0=";
  };

  vendorHash = "sha256-oc85xNPMFeaPC7TMcSh3i3Msd8sCJ5QGFmi2fKjcyvk=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [
    "-s"
    "-w"
    "-extldflags '-static'"
  ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Tunneling/pivoting tool that uses a TUN interface";
    homepage = "https://github.com/tnpitsecurity/ligolo-ng";
    changelog = "https://github.com/nicocha30/ligolo-ng/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
  };
}
