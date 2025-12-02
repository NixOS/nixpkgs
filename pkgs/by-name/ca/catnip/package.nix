{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  portaudio,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "catnip";
  version = "1.8.7";

  src = fetchFromGitHub {
    owner = "noriah";
    repo = "catnip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M9VGpDsBambe9kXyEgDg53pKOSL2zH1ugfSbRgAiaCo=";
  };

  vendorHash = "sha256-Hj453+5fhbUL6YMeupT5D6ydaEMe+ZQNgEYHtCUtTx4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    portaudio
  ];

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Terminal audio visualizer for linux/unix/macOS/windows";
    homepage = "https://github.com/noriah/catnip";
    changelog = "https://github.com/noriah/catnip/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "catnip";
  };
})
