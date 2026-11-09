{
  lib,
  fetchFromGitHub,
  rustPlatform,
  writableTmpDirAsHomeHook,
  gitMinimal,
  gh,
  makeWrapper,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "octorus";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "ushironoko";
    repo = "octorus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VsrF7w+NgfJqlNC0BxoC0ti5f6YTd2CLk5HgtjK0xL0=";
  };

  cargoHash = "sha256-epAMROmX0Kgp5SEDCTLy55bF7ArWzhgq8Phhk/2PINY=";

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    wrapProgram $out/bin/or \
      --prefix PATH : ${
        lib.makeBinPath [
          gh
          gitMinimal
        ]
      }
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "TUI PR review tool for GitHub";
    homepage = "https://github.com/ushironoko/octorus";
    changelog = "https://github.com/ushironoko/octorus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      kangazero
    ];
    mainProgram = "or";
  };
})
