{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ligolo-ng";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "tnpitsecurity";
    repo = "ligolo-ng";
    tag = "v${version}";
    hash = "sha256-+d5dBhB0ABYrGQHZ5ta5hxsAqQop7H/5P4pxNF4MIc0=";
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

  meta = with lib; {
    description = "Tunneling/pivoting tool that uses a TUN interface";
    homepage = "https://github.com/tnpitsecurity/ligolo-ng";
    changelog = "https://github.com/nicocha30/ligolo-ng/releases/tag/v${version}";
    license = licenses.gpl3Only;
  };
}
