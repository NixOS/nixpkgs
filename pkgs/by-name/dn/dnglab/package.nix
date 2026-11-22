{
  fetchFromGitHub,
  installShellFiles,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dnglab";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "dnglab";
    repo = "dnglab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2I7VOJdeJP4NjSosUpRFyPGtbREDkJvJPXbXWImCgpQ=";
  };

  cargoHash = "sha256-BDhfxsd//SJvkiGjaFlZCPLCHFNV55GlzqAN1LDQQfE=";

  strictDeps = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    rm $out/bin/benchmark $out/bin/identify
    installManPage bin/dnglab/manpages/*
    installShellCompletion --zsh bin/dnglab/completions/_dnglab
    installShellCompletion bin/dnglab/completions/dnglab.{fish,bash}
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=v([\\d.]+)" ];
  };

  meta = {
    description = "Camera RAW to DNG file format converter";
    homepage = "https://github.com/dnglab/dnglab";
    license = lib.licenses.lgpl21Only;
    changelog = "https://github.com/dnglab/dnglab/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ VlaDexa ];
    mainProgram = "dnglab";
  };
})
