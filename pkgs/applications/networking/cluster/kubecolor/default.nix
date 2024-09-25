{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubecolor";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jOFeTAfV7X8+z+DBOBOFVcspxZ8QssKFWRGK9HnqBO0=";
  };

  vendorHash = "sha256-b99HAM1vsncq9Q5XJiHZHyv7bjQs6GGyNAMONmGpxms=";

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  subPackages = [
    "."
  ];

  meta = with lib; {
    description = "Colorizes kubectl output";
    mainProgram = "kubecolor";
    homepage = "https://github.com/kubecolor/kubecolor";
    changelog = "https://github.com/kubecolor/kubecolor/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ivankovnatsky SuperSandro2000 applejag ];
  };
}
