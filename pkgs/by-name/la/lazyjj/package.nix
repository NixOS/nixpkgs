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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Cretezy";
    repo = "lazyjj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BmME+LpYv3Ynpbo/k9pA5qcNmv7XLPXasPvHW4QalwY=";
  };

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail \
        'version = "0.5.0"' \
        'version = "0.6.0"'
  '';

  cargoHash = "sha256-bQNLhQAUw2JgThC+RiNC5ap8D6a4JgflV2whXKu7QF8=";

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
