{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  jujutsu,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lazyjj";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Cretezy";
    repo = "lazyjj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xpRuXefP2agcZojvAUvODDOFJoEyTiMztJM3VNCeryA=";
  };

  cargoHash = "sha256-LLbMR3FT5Ci7A9TlhRtU0rpMilXZXb4DH85/R776OQY=";

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [
    jujutsu
  ];

  postInstall = ''
    wrapProgram $out/bin/lazyjj \
      --prefix PATH : ${lib.makeBinPath [ jujutsu ]}
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "TUI for Jujutsu/jj";
    homepage = "https://github.com/Cretezy/lazyjj";
    changelog = "https://github.com/Cretezy/lazyjj/releases/tag/v${finalAttrs.version}";
    mainProgram = "lazyjj";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      colemickens
      GaetanLepage
    ];
  };
})
