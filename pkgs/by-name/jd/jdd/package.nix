{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "jdd";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "mahyarmirrashed";
    repo = "jdd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7iHoLv3DeqjXvcB7Nih+TMKwWYuausIP2Nhv00pfz0A=";
  };

  vendorHash = "sha256-qwrmiVvmsi1uxHVIKuoMBPUK/Y5aYdUR3fUa5tOpNRY=";

  ldflags = [ "-X=main.version=${finalAttrs.version}" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Johnny Decimal daemon for automatically organizing files into the correct drawer using their filename";
    homepage = "https://github.com/mahyarmirrashed/jdd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
    mainProgram = "jdd";
  };
})
