{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rancher";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-puwbZQ6JOdRODOChb2hOqW4KPIxxubOkMILFHUP/I78=";
  };

  ldflags = [
    "-w"
    "-s"
    "-X main.VERSION=${version}"
    "-extldflags"
    "-static"
  ];

  vendorHash = "sha256-NQ5R2rYmPc5Y6tpnWm9/QL5TNe70ZWwXF51KgShyovQ=";

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
