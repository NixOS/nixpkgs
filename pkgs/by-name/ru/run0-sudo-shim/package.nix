{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  coreutils,
  polkit-stdin-agent,
  installShellFiles,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "run0-sudo-shim";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "LordGrimmauld";
    repo = "run0-sudo-shim";
    tag = finalAttrs.version;
    hash = "sha256-J/I7VPXpOwNtEk9H+lbZVT+xJYBsSKgnMlwzlVIJSWk=";
  };

  cargoHash = "sha256-JfxMmYgYLKxVqj8H0/qRGn9z8XNoNpPK3RcIhb/RKOc=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];

  doInstallCheck = true;

  env = {
    POLKIT_STDIN_AGENT = lib.getExe polkit-stdin-agent;
    TRUE = lib.getExe' coreutils "true";
  };

  postInstall = ''
    ln -s $out/bin/run0-sudo-shim $out/bin/sudo
    installManPage target/tmp/run0-sudo-shim/manpage/*
    installShellCompletion \
      target/tmp/run0-sudo-shim/completion/sudo.{bash,fish} \
      --zsh target/tmp/run0-sudo-shim/completion/_sudo
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Shim for the sudo command that utilizes run0";
    changelog = "https://github.com/LordGrimmauld/run0-sudo-shim/releases/tag/${finalAttrs.version}";
    mainProgram = "sudo";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      zimward
      kuflierl
      grimmauld
    ];
  };
})
