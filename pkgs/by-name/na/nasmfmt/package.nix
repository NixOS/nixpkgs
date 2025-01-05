{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "nasmfmt";
  version = "unstable-2022-09-15";

  src = fetchFromGitHub {
    owner = "yamnikov-oleg";
    repo = "nasmfmt";
    rev = "127dbe8e72376c67d7dff89010ccfb49fc7b533e";
    hash = "sha256-1c7ZOdoM0/Us7cnTT3sds2P5pcCedrCfl0GqQBnf9Rk=";
  };

  vendorHash = null;

  preBuild = ''
    go mod init github.com/yamnikov-oleg/nasmfmt
  '';

  ldflags = [ "-s" ];

  meta = with lib; {
    description = "Formatter for NASM source files";
    mainProgram = "nasmfmt";
    homepage = "https://github.com/yamnikov-oleg/nasmfmt";
    license = licenses.mit;
    maintainers = [ ];
  };
}
