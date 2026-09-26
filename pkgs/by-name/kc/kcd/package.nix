{
  lib,
  buildGoModule,
  versionCheckHook,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kcd";
  version = "1.19.1";

  src = fetchFromGitHub {
    owner = "bethropolis";
    repo = "kcd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/bwpPWnSYN3VOeNGRYVKmKY/wHctwA23pI6eOhElSCI=";
  };

  vendorHash = "sha256-/rT2aUVw0AG5oSMq/nTaybsvMUd+bPLMPJR2J1dltic=";
  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Headless KDE Connect Daemon";
    homepage = "https://github.com/bethropolis/kcd";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      leiserfg
    ];
  };
  __structuredAttrs = true;
})
