{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gobuster";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "OJ";
    repo = "gobuster";
    tag = "v${version}";
    hash = "sha256-EUfpCuEbWe0+98b63ITrAeB6GGfu1b9vbP6/5gg/7Nw=";
  };

  vendorHash = "sha256-k3NDFBDMiysrnjiEODrrxLdpePLCzUYD41mZbiYuqAE=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool used to brute-force URIs, DNS subdomains, Virtual Host names on target web servers";
    mainProgram = "gobuster";
    homepage = "https://github.com/OJ/gobuster";
    changelog = "https://github.com/OJ/gobuster/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fab
      pamplemousse
    ];
  };
}
