{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "deterministic-zip";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "timo-reymann";
    repo = "deterministic-zip";
    tag = "${finalAttrs.version}";
    hash = "sha256-rvheo/DkQTfpVy8fVRRwRA4G9mdMNArptxNT0sxdqnc=";
  };

  vendorHash = "sha256-qLVeliB2+qRhF+iRE0zHyhBOTB7q31ZGCEH7kbSLSBA=";

  ldflags = [
    "-s"
    "-X github.com/timo-reymann/deterministic-zip/pkg/buildinfo.GitSha=${finalAttrs.src.rev}"
    "-X github.com/timo-reymann/deterministic-zip/pkg/buildinfo.Version=${finalAttrs.version}"
  ];

  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Simple (almost drop-in) replacement for zip that produces deterministic files";
    mainProgram = "deterministic-zip";
    homepage = "https://github.com/timo-reymann/deterministic-zip";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ rhysmdnz ];
  };
})
