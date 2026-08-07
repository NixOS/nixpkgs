{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "irtt";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "heistp";
    repo = "irtt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b0Od/KWV408PP/rPtqMr+lTyPXlxigLEU2/by6gjfxg=";
  };

  vendorHash = "sha256-Mxdvb1d44dag1/jKjSVAzqYBed/lylyamgwQwj9THl4=";
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = {
    description = "Measures round-trip time, one-way delay and other metrics using UDP";
    homepage = "https://github.com/heistp/irtt";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.tsheinen ];
    mainProgram = "irtt";
    platforms = lib.platforms.linux;
  };
})
