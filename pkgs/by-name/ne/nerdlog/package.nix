{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "nerdlog";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "dimonomid";
    repo = "${finalAttrs.pname}";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5duKO5Ep++M+I8TXhtFpWydikzMC1AQefzFQEQjbeq4=";
  };

  env.CGO_ENABLED = 0;
  env.HOME = "1";
  subPackages = [ "cmd/nerdlog" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dimonomid/nerdlog/version.version=${finalAttrs.version}"
    "-X github.com/dimonomid/nerdlog/version.commit=${finalAttrs.src.rev}"
    "-X github.com/dimonomid/nerdlog/version.date=1970-01-01T00:00:00Z"
    "-X github.com/dimonomid/nerdlog/version.builtBy=nix@nixpkgs"
  ];

  vendorHash = "sha256-J3u8MXUXoMttj4dVKAcuMvqCOsbYzHnulunXxprV8hA=";

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";
  versionCheckDontIgnoreEnvironment = true;

  meta = {
    changelog = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.owner}/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.owner}";
    description = "Fast, remote-first, multi-host TUI log viewer with timeline histogram and no central server";
    license = lib.licenses.bsd2;
    mainProgram = "${finalAttrs.pname}";
    maintainers = with lib.maintainers; [ paepcke ];
  };
})
