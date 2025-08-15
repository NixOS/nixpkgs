{
  lib,
  buildGoModule,
  fetchFromGitHub,
  mpv,
  fzf,
  chafa,
}:

buildGoModule (finalAttrs: {
  pname = "gophertube";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "KrishnaSSH";
    repo = "GopherTube";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xsEK+iSobGOxiCx9lkQcxm6SIplTTbnXwP5/RzJQF+Q=";
  };

  vendorHash = "sha256-WfVoCxzMk+h4AP1zgTNRXTpj8Ltu71YrsQ7OoU3Y4tg=";

  buildInputs = [
    mpv
    fzf
    chafa
  ];

  meta = {
    description = "Terminal user interface for search and watching YouTube videos using mpv and chafa";
    homepage = "https://github.com/KrishnaSSh/GopherTube";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ spreetin ];
    mainProgram = "gophertube";
  };
})
