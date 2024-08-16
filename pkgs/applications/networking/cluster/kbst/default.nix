{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kbst";
  version = "0.2.1";

  src = fetchFromGitHub{
    owner = "kbst";
    repo = "kbst";
    rev = "v${version}";
    hash = "sha256-tbSYNJp/gzEz+wEAe3bvIiZL5axZvW+bxqTOBkYSpMY=";
  };

  vendorHash = "sha256-+FY6KGX606CfTVKM1HeHxCm9PkaqfnT5XeOEXUX3Q5I=";

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

  doCheck = false;

  doPostInstallCheck = true;
  PostInstallCheckPhase = ''
    $out/bin/kbst help | grep v${version} > /dev/null
  '';

  meta = with lib; {
    description = "Kubestack framework CLI";
    mainProgram = "kbst";
    homepage = "https://www.kubestack.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mtrsk ];
  };
}
