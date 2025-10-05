{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rancher";
  version = "2.12.2";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-KVJfeCv+rMPGvKknov1LQX/ndI182p8p+ze2522xb7U=";
  };

  env.CGO_ENABLED = 0;

  ldflags = [
    "-w"
    "-s"
    "-X main.VERSION=${version}"
    "-extldflags"
    "-static"
  ];

  vendorHash = "sha256-guxr/co4IJoX+mSBPFqdjo8C/QnRIXcd/RztNdnfVQM=";

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
    maintainers = with maintainers; [ bryanasdev000 ];
  };
}
