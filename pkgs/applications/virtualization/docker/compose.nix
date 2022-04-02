{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "docker-compose";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
    rev = "v${version}";
    sha256 = "sha256-ZFnrfGM2LUZZC8IPPCh3GS95jz7NGraOlr3wQaw5K0k=";
  };

  vendorSha256 = "sha256-Y2rE5/XLmQLqBA8xiCd9v30gTaO9qbiBFa4jKucKU6M=";

  ldflags = [ "-X github.com/docker/compose/v2/internal.Version=${version}" "-s" "-w" ];

  doCheck = false;
  installPhase = ''
    install -D $GOPATH/bin/cmd $out/libexec/docker/cli-plugins/docker-compose
  '';

  meta = with lib; {
    description = "Docker CLI plugin to define and run multi-container applications with Docker";
    homepage = "https://github.com/docker/compose";
    license = licenses.asl20;
    maintainers = with maintainers; [ babariviere SuperSandro2000 ];
  };
}
