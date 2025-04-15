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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "oligot";
    repo = "go-mod-upgrade";
    tag = "v${version}";
    hash = "sha256-RjP9Yt3jzLcgkPKFboMnOZw0qRJQzSRstQtadj8bzlI=";
  };

  vendorHash = "sha256-Qx+8DfeZyNSTf5k4juX7+0IXT4zY2LJMuMw3e1HrxBs=";

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
