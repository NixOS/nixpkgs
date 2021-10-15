{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rancher-cli";
  version = "2.4.13";

  src = fetchFromGitHub {
    owner  = "rancher";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "sha256-tkAnbQP35P+ZEE/WTpjgjdmvt0eJ0esKJ+I21cWraEI=";
  };

  ldflags = [
    "-w"
    "-s"
    "-X main.VERSION=${version}"
    "-extldflags"
    "-static"
  ];

  vendorSha256 = "sha256-agXztvvrMEoa6bo/bQr3qhinOSj7bFnZ4kzTx4F0VxQ=";

  postInstall = ''
    mv $out/bin/cli $out/bin/rancher
  '';

  doCheck = true;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/rancher | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "The Rancher Command Line Interface (CLI) is a unified tool for interacting with your Rancher Server";
    homepage = "https://github.com/rancher/cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ bryanasdev000 ];
  };
}
