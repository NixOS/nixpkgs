{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  pandoc,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "nprt";
  version = "1.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "thatsneat-dev";
    repo = "nprt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qA3iGRTx00kH7k6SzDQl4y6JyDd50c+9MUS/mWQQ194=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  postBuild = ''
    pandoc docs/USAGE.md -s -t man -o nprt.1
  '';

  postInstall = ''
    installManPage nprt.1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool to track which nixpkgs channels contain a given pull request";
    homepage = "https://github.com/thatsneat-dev/nprt";
    changelog = "https://github.com/thatsneat-dev/nprt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wini ];
    mainProgram = "nprt";
  };
})
