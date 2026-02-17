{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rancher";
  version = "2.13.2";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5nGUxdhMhhwDaVRwURis3FElMonwoe8h6M09EDwf+Bc=";
  };

  env.CGO_ENABLED = 0;

  ldflags = [
    "-w"
    "-s"
    "-X main.VERSION=${finalAttrs.version}"
    "-extldflags"
    "-static"
  ];

  vendorHash = "sha256-CQkM7zC5RPCguGp6dxBSjnDkWe11hp5v6QwZ6kRAXQE=";

  postInstall = ''
    mv $out/bin/cli $out/bin/rancher
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/rancher | grep ${finalAttrs.version} > /dev/null
  '';

  meta = {
    description = "CLI tool for interacting with your Rancher Server";
    mainProgram = "rancher";
    homepage = "https://github.com/rancher/cli";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
