{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kbst";
  version = "0.1.5";

  src = fetchFromGitHub{
    owner = "kbst";
    repo = "kbst";
    rev = "v${version}";
    sha256 = "0cz327fl6cqj9rdi8zw6xrazzigjymhn1hsbjr9xxvfvfnn67xz2";
  };

  ldflags =
    let package_url = "github.com/kbst/kbst"; in
    [
      "-s" "-w"
      "-X ${package_url}.version=${version}"
      "-X ${package_url}.buildDate=unknown"
      "-X ${package_url}.gitCommit=${src.rev}"
      "-X ${package_url}.gitTag=v${version}"
      "-X ${package_url}.gitTreeState=clean"
    ];

  vendorSha256 = "sha256-DZ47Bj8aFfBnxU9+e1jZiTMF75rCJtcj4yUfZRJWCic=";

  doCheck = false;

  doPostInstallCheck = true;
  PostInstallCheckPhase = ''
    $out/bin/kbst help | grep v${version} > /dev/null
  '';

  meta = with lib; {
    description = "Kubestack framework CLI";
    homepage = "https://www.kubestack.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mtrsk ];
  };
}
