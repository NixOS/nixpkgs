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
buildGoModule rec {
  pname = "ctags-lsp";
  version = "0.6.1";
  vendorHash = null;

  src = fetchFromGitHub {
    owner = "netmute";
    repo = "ctags-lsp";
    tag = "v${version}";
    hash = "sha256-wSccfhVp1PDn/gj46r8BNskEuBuRIx1wydYAW1PV4cg=";
  };

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
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
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/netmute/ctags-lsp/releases/tag/v${version}";
    description = "LSP implementation using universal-ctags as backend";
    homepage = "https://github.com/netmute/ctags-lsp";
    license = lib.licenses.mit;
    mainProgram = "ctags-lsp";
    maintainers = with lib.maintainers; [ voronind ];
  };
}
