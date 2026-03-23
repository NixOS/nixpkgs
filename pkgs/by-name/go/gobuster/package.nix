{
  lib,
  buildGo125Module,
  fetchFromGitHub,
}:

buildGo125Module rec {
  pname = "gobuster";
  version = "3.8.2";

  src = fetchFromGitHub {
    owner = "OJ";
    repo = "gobuster";
    tag = "v${version}";
    hash = "sha256-/woa0w/+aa1S2+Om5EK8I1XEI1mI47vNS1+GDnQHlTA=";
  };

  __darwinAllowLocalNetworking = true;

  vendorHash = "sha256-rTN8omPTfSVfp/ythGWxVyq6rR7tJCN2znwMGixiw90=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool used to brute-force URIs, DNS subdomains, Virtual Host names on target web servers";
    homepage = "https://github.com/OJ/gobuster";
    changelog = "https://github.com/OJ/gobuster/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fab
      pamplemousse
    ];
    mainProgram = "gobuster";
  };
}
