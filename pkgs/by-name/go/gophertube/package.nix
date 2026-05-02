{
  lib,
  buildGoModule,
  fetchFromGitHub,
  yt-dlp,
  mpv,
  fzf,
  chafa,
  makeBinaryWrapper,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gophertube";
  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "KrishnaSSH";
    repo = "GopherTube";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SGTFSD/xqFvU9zvzCv95JTK41cuUybHmJ8OcHdfq+eE=";
  };

  vendorHash = "sha256-905OkZNMoGbRHNYV4Fg4E7PyK/E+gzCDyzCLccGsEsc=";

  ldflags = [
    "-X gophertube/internal/app.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "-v";

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
