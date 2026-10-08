{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "drift";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "phlx0";
    repo = "drift";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PEKVwtJGYgyaV31OUMDHbYqS948GqBZ1/gb/n12D3Fo=";
  };

  vendorHash = "sha256-xcSoDytK7cQrECa5PVoLunCG5im2YbOd8/0bclvTaq0=";

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.tag}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal screensaver that turns idle time into ambient art";
    longDescription = ''
      Constellations, rain, particles & braille waves.  Press any key
      to resume.

      Every OS has a screensaver.  The terminal had nothing — until
      now.
    '';
    homepage = "https://github.com/phlx0/drift";
    changelog = "https://github.com/phlx0/drift/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mana-byte
      yiyu
    ];
    mainProgram = "drift";
  };
})
