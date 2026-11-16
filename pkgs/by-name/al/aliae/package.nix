{
  lib,
  stdenv,
  buildGo127Module,
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "aliae";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "jandedobbeleer";
    repo = "aliae";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DaEkrwm6iMuC9ZJhrpd5SR3ZlwxBqxrwQSWqBlviC94=";
  };

  vendorHash = "sha256-mEHdwZmWS/F+vUyA3Dc1pMH95OxfN1leKayB6u5vRGQ=";

  sourceRoot = "${finalAttrs.src.name}/src";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  tags = [
    "netgo"
    "osusergo"
  ];

  postInstall = ''
    mv $out/bin/{src,aliae}
  ''
  + lib.optionalString (stdenv.buildPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd aliae \
        --bash <(${emulator} $out/bin/aliae completion bash) \
        --fish <(${emulator} $out/bin/aliae completion fish) \
        --zsh <(${emulator} $out/bin/aliae completion zsh)
    ''
  );

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = {
    description = "Cross shell and platform alias management";
    mainProgram = "aliae";
    homepage = "https://aliae.dev";
    changelog = "https://github.com/JanDeDobbeleer/aliae/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vedantmgoyal9 ];
  };
})
