{
  buildGoModule,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "stc";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "tenox7";
    repo = "stc";
    rev = finalAttrs.version;
    sha256 = "sha256-/h5T7xzUvguHhrE1DyIep/z7Xt1jNdDFtWeQdpwq6iE=";
  };

  vendorHash = "sha256-M86CoiTN03a7cXtUobsO8CYmfcRsVrHaekIPiYIeV50=";

  ldflags = [ "-X main.GitTag=${finalAttrs.version}" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  meta = {
    description = "Syncthing CLI Tool";
    homepage = "https://github.com/tenox7/stc";
    changelog = "https://github.com/tenox7/stc/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ivankovnatsky ];
    mainProgram = "stc";
  };
})
