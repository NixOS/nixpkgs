{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "markscribe";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "markscribe";
    rev = "v${version}";
    hash = "sha256-I8WSG9rMqgf2QADQetlYTSUIQH1Iv8cMVw/3uIwEDPc=";
  };

  vendorHash = "sha256-leeP2+W+bnYASls3k0l4jpz1rc1mAkMWUfrY2uBUUdQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Your personal markdown scribe with template-engine and Git(Hub) & RSS powers";
    mainProgram = "markscribe";
    homepage = "https://github.com/muesli/markscribe";
    changelog = "https://github.com/muesli/markscribe/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
