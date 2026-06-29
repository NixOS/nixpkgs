{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;
  pname = "kitops";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "kitops-ml";
    repo = "kitops";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ySn91TIkWOd3myjcscmcN0jhbjp0mAYm9R2nG0bnTVo=";
  };

  vendorHash = "sha256-lT1xSuwEZMVjy18pQSuqybfgULyagJX4hCWUYdNrQ8M=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X github.com/kitops-ml/kitops/pkg/lib/constants.Version=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/kitops $out/bin/kit
  '';

  # The testing/ integration suite requires network access.
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  # kit's root command resolves a config home directory via $KITOPS_HOME
  # (falling back to XDG-style paths); without it the version subcommand
  # exits before printing its version, so point it at TMPDIR for the check.
  # versionCheckHook wipes the environment unless the var is listed here.
  versionCheckKeepEnvironment = [ "KITOPS_HOME" ];
  preVersionCheck = ''
    export KITOPS_HOME="$TMPDIR"
  '';

  meta = {
    description = "Open source DevOps tool for packaging and versioning AI/ML models, datasets, code, and configuration into an OCI Artifact";
    homepage = "https://github.com/kitops-ml/kitops";
    changelog = "https://github.com/kitops-ml/kitops/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gbhu753 ];
    mainProgram = "kit";
  };
})
