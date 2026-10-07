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
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "oligot";
    repo = "go-mod-upgrade";
    tag = "v${version}";
    hash = "sha256-eBes8PDx3E8hAcSXiRmEJTelsm7EWtI3Ffsl5RIAVJ8=";
  };

  vendorHash = "sha256-92lKUBkSx5Rvm1FfZLAd3LZS+TPAasRYOMFLTt/QzXc=";

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
