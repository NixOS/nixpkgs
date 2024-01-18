{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "popeye";
  version = "0.11.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "derailed";
    repo = "popeye";
    sha256 = "sha256-2mLbBvdUWGspTNeU3QJzR5NDI24njvRO2nss/Bo93W8=";
  };

  ldflags = [
    "-s" "-w"
    "-X github.com/derailed/popeye/cmd.version=${version}"
    "-X github.com/derailed/popeye/cmd.commit=${version}"
  ];

  vendorHash = "sha256-Vt5QwggdasVk4j2huSIneBMemi3Q0R4MgZn2yNlOH5E=";

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/popeye version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "A Kubernetes cluster resource sanitizer";
    homepage = "https://github.com/derailed/popeye";
    changelog = "https://github.com/derailed/popeye/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.bryanasdev000 ];
  };
}
