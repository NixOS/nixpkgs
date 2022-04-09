{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "popeye";
  version = "0.9.8";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "derailed";
    repo = "popeye";
    sha256 = "sha256-uGy2BbZS4SGT0w9ICYPUIfFawSvIVMsEezPfPAPQU/Q=";
  };

  ldflags = [
    "-s" "-w"
    "-X github.com/derailed/popeye/cmd.version=${version}"
    "-X github.com/derailed/popeye/cmd.commit=${version}"
  ];

  vendorSha256 = "sha256-vUUDLMicop5QzZmAHi5qrc0hx8oV2xWNFHvCWioLhl8=";

  doCheck = true;

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
