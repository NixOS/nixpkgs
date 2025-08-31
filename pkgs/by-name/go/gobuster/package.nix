{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gobuster";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "OJ";
    repo = "gobuster";
    tag = "v${version}";
    hash = "sha256-ddTu13jbleylrcas93pGL98d0mE+2HNlPCVO+0iCP/4=";
  };

  vendorHash = "sha256-h/ZJeHk0J8qOC/ZWw6gaHwy5mIE7RuZulITbhTpQJi8=";

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
