{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "popeye";
  version = "0.11.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "derailed";
    repo = "popeye";
    sha256 = "sha256-A1jUlEgjBoiN+NYwpyW/1eYzkCK3UuPID++fu+zGvzk=";
  };

  ldflags = [
    "-s" "-w"
    "-X github.com/derailed/popeye/cmd.version=${version}"
    "-X github.com/derailed/popeye/cmd.commit=${version}"
  ];

  vendorHash = "sha256-MEsChBBn0mixgJ7pzRoqAqup75b/mVv6k3OMmzgyLC4=";

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
