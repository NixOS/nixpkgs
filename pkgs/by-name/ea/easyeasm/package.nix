{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  amass,
  alterx,
  oam-tools,
  subfinder,
}:

buildGoModule rec {
  pname = "easyeasm";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "g0ldencybersec";
    repo = "EasyEASM";
    tag = "v${version}";
    hash = "sha256-/PhoH+5k63rJL1N3V3IL1TP1oacsBfGfVw/OueN9j8M=";
  };

  vendorHash = "sha256-g+yaVIx4jxpAQ/+WrGKxhVeliYx7nLQe/zsGpxV4Fn4=";

  nativeBuildInputs = [
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  postFixup = ''
    wrapProgram $out/bin/easyeasm \
      --prefix PATH : "${
        lib.makeBinPath [
          amass
          alterx
          oam-tools
          subfinder
        ]
      }"
  '';

  meta = {
    description = "Attack surface management tool";
    homepage = "https://github.com/g0ldencybersec/EasyEASM";
    changelog = "https://github.com/g0ldencybersec/EasyEASM/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "easyeasm";
  };
}
