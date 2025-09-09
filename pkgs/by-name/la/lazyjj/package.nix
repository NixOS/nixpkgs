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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Cretezy";
    repo = "lazyjj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pz2q+uyr8r5G5Zs5mC/nvHdK6hTpiLBzjgUmvd5dwZw=";
  };

  cargoHash = "sha256-70xKyzRFMyAKhSwEsdNBK2afs0UpVoTvIXuQJgeqYY8=";

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

  meta = {
    description = "TUI for Jujutsu/jj";
    homepage = "https://github.com/Cretezy/lazyjj";
    changelog = "https://github.com/Cretezy/lazyjj/releases/tag/v${finalAttrs.version}";
    mainProgram = "lazyjj";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ colemickens ];
  };
})
