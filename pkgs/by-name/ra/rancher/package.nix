{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rancher";
  version = "2.13.4";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3/8xGp8jmmfvblikNSNUxXd6w1PJnvgraGthEmOesXI=";
  };

  env.CGO_ENABLED = 0;

  ldflags = [
    "-w"
    "-s"
    "-X main.VERSION=${finalAttrs.version}"
    "-extldflags"
    "-static"
  ];

  vendorHash = "sha256-nEmnbWhDQg7/KHcRYQvrxzFRSHmbOwpEq2H44Pizmuk=";

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
