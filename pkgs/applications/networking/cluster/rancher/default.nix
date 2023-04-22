{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rancher";
  version = "2.6.11";

  src = fetchFromGitHub {
    owner  = "rancher";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "sha256-1hIYFQ9Uwrm6chPXka0yK2XoZYHqv5lJoyENZmgMAwc=";
  };

  ldflags = [
    "-w"
    "-s"
    "-X main.VERSION=${version}"
    "-extldflags"
    "-static"
  ];

  vendorHash = "sha256-oclMnt6uJa8SG2fNM0fi+HCVMMi4rkykx8VpK/tXilQ=";

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
