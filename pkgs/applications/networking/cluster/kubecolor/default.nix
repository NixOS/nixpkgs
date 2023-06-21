{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubecolor";
  version = "0.0.25";

  src = fetchFromGitHub {
    owner = "hidetatz";
    repo = "kubecolor";
    rev = "v${version}";
    sha256 = "sha256-FyKTI7Br9BjSpmf9ch2E4EZAWM7/jowZfRrCn4GTcps=";
  };

  vendorSha256 = "sha256-DLj7ztOFNmDru1sO+ezecQeRbIbOq49M4EcJuWLNstI=";

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  meta = with lib; {
    description = "Colorizes kubectl output";
    homepage = "https://github.com/hidetatz/kubecolor";
    changelog = "https://github.com/hidetatz/kubecolor/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
