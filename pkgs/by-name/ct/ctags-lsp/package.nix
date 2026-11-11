{
  buildGoModule,
  fetchFromGitHub,
  git,
  jujutsu,
  lib,
  makeWrapper,
  nix-update-script,
  universal-ctags,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "ctags-lsp";
  version = "0.11.0";
  vendorHash = null;

  src = fetchFromGitHub {
    owner = "netmute";
    repo = "ctags-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9VKXdffK46gl7MLN1kpSpQRIoJzu4nTS9C1r//qsOuo=";
  };

  nativeBuildInputs = [ makeWrapper ];
  nativeCheckInputs = [ universal-ctags ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/ctags-lsp \
      --suffix PATH : ${
        lib.makeBinPath [
          universal-ctags
          git
          jujutsu
        ]
      }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/netmute/ctags-lsp/releases/tag/v${finalAttrs.version}";
    description = "LSP implementation using universal-ctags as backend";
    homepage = "https://github.com/netmute/ctags-lsp";
    license = lib.licenses.mit;
    mainProgram = "ctags-lsp";
    maintainers = with lib.maintainers; [ voronind ];
  };
})
