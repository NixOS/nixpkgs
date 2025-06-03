{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rancher";
  version = "2.11.2";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-C7Ihl7JnURltVk6Qt7H/UYeHqjcfKuFyFCFx8ENPDyI=";
  };

  ldflags = [
    "-w"
    "-s"
    "-X main.VERSION=${version}"
    "-extldflags"
    "-static"
  ];

  vendorHash = "sha256-eUA+hm+vuVUpkF7ojruEydkXbtMM58i0Ka+6Z9G4EYQ=";

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
