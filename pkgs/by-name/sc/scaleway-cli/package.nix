{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "scaleway-cli";
  version = "2.47.0";

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "scaleway-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SV3fwEOGLttfpCsQTMfzsSviJ+YIDzZZXUHBCDPtF6g=";
  };

  vendorHash = "sha256-KbjdNGIvvKnv4bbV8YhXYCY0F94C/CUtXiyEnnF2eeA=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.src.tag}"
    "-X main.GitCommit=${finalAttrs.src.rev}"
    "-X main.GitBranch=HEAD"
    "-X main.BuildDate=1970-01-01T00:00:00Z"
  ];

  subPackages = [
    "cmd/scw"
    "commands/..."
    "core/..."
    "internal/..."
  ];

  nativeBuildInputs = [ installShellFiles ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/scw autocomplete script basename=scw shell=bash >scw.bash
    $out/bin/scw autocomplete script basename=scw shell=fish >scw.fish
    echo '#compdef scw' >scw.zsh
    $out/bin/scw autocomplete script basename=scw shell=zsh >>scw.zsh
    installShellCompletion scw.{bash,fish,zsh}
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "version";

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Command Line Interface for Scaleway";
    homepage = "https://github.com/scaleway/scaleway-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nickhu
      techknowlogick
      kashw2
    ];
    mainProgram = "scw";
  };
})
