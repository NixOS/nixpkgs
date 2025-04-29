{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ligolo-ng";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "tnpitsecurity";
    repo = "ligolo-ng";
    tag = "v${version}";
    hash = "sha256-9+n6d9bY9VJiMsgvFNhbdkZ5S1Eo0YxyakuOocMvCdE=";
  };

  vendorHash = "sha256-1K9T7jbQxrnf9j/oa8UvZFatYOiDnJCrMc0DoFGo73U=";

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
