{
  fetchFromGitHub,
  lib,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  stdenvNoCC,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "code";
  version = "0.6.53";

  src = fetchFromGitHub {
    owner = "just-every";
    repo = "code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lKe6OKIrf1k8sJpWIEippbvwamTWLe0uP1KOg7UsY6A=";
  };

  sourceRoot = "${finalAttrs.src.name}/code-rs";

  cargoHash = "sha256-Yo8g9GavX9lrIHGoTs8YzMJkVyABflaRa3ni0xf7EvQ=";

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    openssl
  ];

  env.CODE_VERSION = finalAttrs.version;

  cargoBuildFlags = [
    "--bin"
    "code"
    "--bin"
    "code-tui"
    "--bin"
    "code-exec"
  ];

  # Takes too much time
  doCheck = false;

  postInstall = ''
    ln -s $out/bin/code $out/bin/coder
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, effective, mind-blowing, coding CLI";
    homepage = "https://github.com/just-every/code";
    downloadPage = "https://github.com/just-every/code/releases";
    changelog = "https://github.com/just-every/code/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ prince213 ];
    mainProgram = "coder";
    priority = 10;
  };
})
