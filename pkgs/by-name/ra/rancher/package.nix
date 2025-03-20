{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rancher";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-7lsv974XjD8tBt19FrLkKieec0jQ/0wf8ETLSNdQsH0=";
  };

  ldflags = [
    "-w"
    "-s"
    "-X main.VERSION=${version}"
    "-extldflags"
    "-static"
  ];

  vendorHash = "sha256-t7Gjm9EKpYwSe2ORcFyolsAcyN8Xndtw03zBqFNeePg=";

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
