{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ec";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "chojs23";
    repo = "ec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bVUe9UCi+zJH1qx3JFCNxRNX8hgdIGHkRvGpP8ANx38=";
  };

  vendorHash = "sha256-7OjCWmOoTYTbZ1XXevkrHEGx9Q0qdBqUBo10kvBDDPA=";

  postPatch = ''
    substituteInPlace cmd/ec/main.go \
      --replace-fail \
        'var version = "dev"' \
        'var version = "${finalAttrs.version}"'
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ git ];

  postInstall = ''
    wrapProgram $out/bin/ec --prefix PATH : ${
      lib.makeBinPath [
        git
      ]
    }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Easy terminal-native 3-way git conflict resolver vim-like workflow";
    homepage = "https://github.com/chojs23/ec";
    changelog = "https://github.com/chojs23/ec/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kpbaks
      neo
    ];
    mainProgram = "ec";
  };
})
