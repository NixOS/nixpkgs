{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "drift";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "phlx0";
    repo = "drift";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oSSuh4LNihLoy4qwMx97+oCuapp18d2GV52bq4yXcqE=";
  };

  vendorHash = "sha256-FsNa9qp2MnPk1onv/O13mFi+82yP7D4LdILZsNzHs+4=";

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
