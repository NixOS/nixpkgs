{
  fetchFromGitHub,
  installShellFiles,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rusk";
  version = "0.7.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tagirov";
    repo = "rusk";
    tag = finalAttrs.version;
    hash = "sha256-KIi37AxDLBO2rHd+kAaQAz2Wbr+FYscrRmPsy1x6QeY=";
  };

  cargoHash = "sha256-LxlGC+pJ+gxklUZ/uGwlSDkDWNetFJQNUco/VADWpv4=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion completions/rusk.{bash,fish,zsh}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimal terminal task manager";
    homepage = "https://github.com/tagirov/rusk";
    changelog = "https://github.com/tagirov/rusk/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "rusk";
  };
})
