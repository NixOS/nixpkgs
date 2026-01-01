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
<<<<<<< HEAD
  version = "0.9.1";
=======
  version = "0.9.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  vendorHash = null;

  src = fetchFromGitHub {
    owner = "netmute";
    repo = "ctags-lsp";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-QF1TBHo2/2Hsnbv4kDw/RYUw9pN8fAVX11lE3J1/k8I=";
=======
    hash = "sha256-CcaYwfmWtBoyAkgF1xwBjNG3MtSa94x2/prW6VQpbQ0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
