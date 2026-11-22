{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "go-mod-upgrade";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "oligot";
    repo = "go-mod-upgrade";
    tag = "v${version}";
    hash = "sha256-7xS8KFsp4fDUgLhCwdIDDHR1yM8TpO3IMpgG1VP/2D0=";
  };

  vendorHash = "sha256-U6v8gxOca1p69Ec2pAO95sYtbaI7OyiJ1uFgqrZ3xr0=";

  ldflags = [
    "-X main.version=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Update outdated Go dependencies interactively";
    changelog = "https://github.com/oligot/go-mod-upgrade/releases/tag/v${version}/CHANGELOG.md";
    homepage = "https://github.com/oligot/go-mod-upgrade";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ polyfloyd ];
  };
}
