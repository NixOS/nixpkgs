{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rancher";
  version = "2.6.9";

  src = fetchFromGitHub {
    owner  = "rancher";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "sha256-co4LVd5A0bJ4CIuCfv6WyV8XCMbPCFAAcV12WekYrw4=";
  };

  ldflags = [
    "-w"
    "-s"
    "-X main.VERSION=${version}"
    "-extldflags"
    "-static"
  ];

  vendorSha256 = "sha256-oclMnt6uJa8SG2fNM0fi+HCVMMi4rkykx8VpK/tXilQ=";

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
