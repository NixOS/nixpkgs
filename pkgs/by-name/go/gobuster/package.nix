{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gobuster";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "OJ";
    repo = "gobuster";
    tag = "v${version}";
    hash = "sha256-RiT9WUvMCv64Q1kl3WoZ6hu8whpAuG2SN6S0897SE2k=";
  };

  vendorHash = "sha256-3okd9ixxfFJTVYMj3qLnezfeR6esfagEfUNfWl6Oo60=";

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
