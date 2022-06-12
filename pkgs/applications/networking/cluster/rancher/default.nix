{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rancher";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner  = "rancher";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "sha256-5ceyScsCidJpHGfwhsq7/hDd3CClx29cD5Cdc1PSxTU=";
  };

  ldflags = [
    "-w"
    "-s"
    "-X main.VERSION=${version}"
    "-extldflags"
    "-static"
  ];

  vendorSha256 = "sha256-Nay4YkUNXuH7vTK3ergILF0efCF1XyJZd2wBiT6fims=";

  postInstall = ''
    mv $out/bin/cli $out/bin/rancher
  '';

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
