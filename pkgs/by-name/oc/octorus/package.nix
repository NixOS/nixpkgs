{
  lib,
  fetchFromGitHub,
  rustPlatform,
  writableTmpDirAsHomeHook,
  gitMinimal,
  gh,
  makeWrapper,
  pkg-config,
  oniguruma,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "octorus";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "ushironoko";
    repo = "octorus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xxbsLeQYrFC1tJMFSQeRasLtHgaRx/i010rmzse58+8=";
  };

  cargoHash = "sha256-UcemyPEh991EW4Uuvoxdp1jpuL3DEosRnugGoECdATA=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [ oniguruma ];

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
