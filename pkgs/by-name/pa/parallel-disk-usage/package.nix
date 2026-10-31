{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "parallel-disk-usage";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "KSXGitHub";
    repo = "parallel-disk-usage";
    tag = finalAttrs.version;
    hash = "sha256-fxEiZGdBUYmPcTPDpcwlB8xYcA/zC+HBspNAUpg0Rgg=";
  };

  cargoHash = "sha256-goPN4O2HfSqyzfvJ8c6NqHSA3+S54tE8SgiYoAaeUW4=";

  nativeBuildInputs = [ installShellFiles ];

  checkFlags = [
    "--skip=cross_device_excludes_mount"
  ];

  postInstall = ''
    installManPage exports/pdu.1

    installShellCompletion --cmd pdu \
      --bash exports/completion.bash \
      --fish exports/completion.fish \
      --zsh exports/completion.zsh
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Highly parallelized, blazing fast directory tree analyzer";
    homepage = "https://github.com/KSXGitHub/parallel-disk-usage";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.peret ];
    mainProgram = "pdu";
  };
})
