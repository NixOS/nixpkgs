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
    rev = "v${version}";
    hash = "sha256-w+3kfLTWHyVs6euIzeN8IlGOww7YYxMizRczPQ8ABc8=";
  };

  ldflags = [
    "-w"
    "-s"
    "-X main.VERSION=${version}"
    "-extldflags"
    "-static"
  ];

  vendorHash = "sha256-JUdUPsF7sFnQoXLAtbE/ueonkbK7wAr4jscFM+h5l4Y=";

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
