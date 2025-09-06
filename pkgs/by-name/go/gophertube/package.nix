{
  lib,
  buildGoModule,
  fetchFromGitHub,
  yt-dlp,
  mpv,
  fzf,
  chafa,
  makeBinaryWrapper,
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

  nativeBuildInputs = [ makeBinaryWrapper ];

  propagatedUserEnvPkgs = [
    yt-dlp
    mpv
    fzf
    chafa
  ];

  postInstall = ''
    wrapProgram $out/bin/gophertube \
      --suffix PATH : ${lib.makeBinPath finalAttrs.propagatedUserEnvPkgs}
  '';

  meta = {
    description = "Terminal user interface for search and watching YouTube videos using mpv and chafa";
    homepage = "https://github.com/KrishnaSSh/GopherTube";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      spreetin
      yiyu
    ];
    mainProgram = "gophertube";
  };
})
