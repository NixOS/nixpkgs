{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kpx";
  version = "1.13.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "momiji";
    repo = "kpx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vsvSux1Gc9DvFnSPX06bfGuNc6Vj005pieQcS47qXDg=";
  };

  vendorHash = null;

  subPackages = [ "cli" ];

  ldflags = [
    "-s"
    "-X=github.com/momiji/kpx.AppVersion=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  # Tests are container-based
  doCheck = false;

  postInstall = ''
    mv $out/bin/cli $out/bin/kpx
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kerberos proxy with dynamic proxy selection";
    homepage = "https://github.com/momiji/kpx";
    changelog = "https://github.com/momiji/kpx/blob/${finalAttrs.src.rev}/CHANGELOG_old.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "kpx";
  };
})
