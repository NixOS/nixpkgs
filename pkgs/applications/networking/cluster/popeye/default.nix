{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "popeye";
  version = "0.9.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "derailed";
    repo = "popeye";
    sha256 = "sha256-GSH9q0hnyuGiJAdbFWKbaaYoHKl4e0SNmBkOvpn5a6s=";
  };

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/derailed/popeye/cmd.version=${version}
      -X github.com/derailed/popeye/cmd.commit=${version}
  '';

  vendorSha256 = "sha256-pK04vGL9Izv1aK8UA+/3lSt/SjLyckjnfSCrOalRj3c=";

  doCheck = true;

  meta = with lib; {
    description = "A Kubernetes cluster resource sanitizer";
    homepage = "https://github.com/derailed/popeye";
    changelog = "https://github.com/derailed/popeye/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.bryanasdev000 ];
    platforms = platforms.linux;
  };
}
