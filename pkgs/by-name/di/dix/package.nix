{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dix";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "faukah";
    repo = "dix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5mn79jtV9gct4LdU5tdz7Q7GHTM2v0Cb2cso0A0dZX0=";
  };

  cargoHash = "sha256-1DtxGaahPFGZcQMX8GHZ0jSpMqSRIGKE3pZSdCVoKnU=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/faukah/dix";
    description = "Blazingly fast tool to diff Nix related things";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      faukah
      NotAShelf
    ];
    mainProgram = "dix";
  };
})
