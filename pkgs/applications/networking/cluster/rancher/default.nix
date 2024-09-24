{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rancher";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner  = "rancher";
    repo   = "cli";
    rev    = "v${version}";
    hash   = "sha256-YyNzqihoQNMmROLeD7/KOU6mTe/UMKgRwGPxCjIglDM=";
  };

  ldflags = [
    "-w"
    "-s"
    "-X main.VERSION=${version}"
    "-extldflags"
    "-static"
  ];

  vendorHash = "sha256-BvT5Awn4o8AbCSaUPLuAIsayC2oj2to4VSZpxQlKKSM=";

  postInstall = ''
    mv $out/bin/cli $out/bin/rancher
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/rancher | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "Rancher Command Line Interface (CLI) is a unified tool for interacting with your Rancher Server";
    mainProgram = "rancher";
    homepage = "https://github.com/rancher/cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ bryanasdev000 ];
  };
}
