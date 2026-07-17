{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "bbrew";
  version = "2.3.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Valkyrie00";
    repo = "bold-brew";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g74rBvBlw/rlLmZdJtIeIp0sba0Q6kFyhlHTwegOA+0=";
  };

  vendorHash = "sha256-5gFyfyerRKfq0uGkyIJ1W4XLhyRR5qPyhc/f2Y2skrI=";

  subPackages = [ "cmd/bbrew" ];

  ldflags = [
    "-s"
    "-w"
    "-X bbrew/internal/services.AppVersion=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for managing Homebrew, Flatpak, and Mac App Store packages";
    homepage = "https://bold-brew.com";
    changelog = "https://github.com/Valkyrie00/bold-brew/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyceherrman ];
    platforms = lib.platforms.unix;
    mainProgram = "bbrew";
  };
})
