{
  lib,
  buildGoModule,
  codex,
  fetchFromGitHub,
  makeWrapper,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "codex-history";
  version = "0.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "HizKz";
    repo = "codex-history";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0cm/tCg2Na6ojNIXupmHKTkkyFqtFNWVTORnbFe0bno=";
  };

  vendorHash = "sha256-eA9P3TJHxwmfgmeqpj0SufJx/p2Bt+gAC0+Q/TwSetE=";

  subPackages = [ "cmd/codex-history" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/HizKz/codex-history/internal/buildinfo.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/codex-history \
      --prefix PATH : ${lib.makeBinPath [ codex ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Browse, search, and resume local Codex conversations";
    homepage = "https://github.com/HizKz/codex-history";
    changelog = "https://github.com/HizKz/codex-history/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ HizKz ];
    mainProgram = "codex-history";
    platforms = lib.platforms.unix;
  };
})
