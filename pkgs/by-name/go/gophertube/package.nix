{
  lib,
  pkgs,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gophertube";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "KrishnaSSH";
    repo = "GopherTube";
    rev = "v${version}";
    sha256 = "sha256-xsEK+iSobGOxiCx9lkQcxm6SIplTTbnXwP5/RzJQF+Q=";
  };

  vendorHash = "sha256-WfVoCxzMk+h4AP1zgTNRXTpj8Ltu71YrsQ7OoU3Y4tg=";

  buildInputs = with pkgs; [
    mpv
    fzf
    chafa
  ];

  meta = with lib; {
    description = "Terminal user interface for search and watching YouTube videos using mpv and chafa";
    homepage = "https://github.com/KrishnaSSh/GopherTube";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.spreetin ];
    mainProgram = "gophertube";
  };
}
