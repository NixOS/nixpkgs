{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rancher";
  version = "2.12.3";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-i+l+vs+uD6h0GruvxhkQtb7DYCJ3uysa/rZ8hGmmu7Y=";
  };

  env.CGO_ENABLED = 0;

  ldflags = [
    "-w"
    "-s"
    "-X main.VERSION=${version}"
    "-extldflags"
    "-static"
  ];

  vendorHash = "sha256-mObfou6JXQ+ZWvxWMpdcC1ymngFJZ8k9I+rCYCFvDg4=";

  postInstall = ''
    mv $out/bin/cli $out/bin/rancher
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/rancher | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "CLI tool for interacting with your Rancher Server";
    mainProgram = "rancher";
    homepage = "https://github.com/rancher/cli";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
