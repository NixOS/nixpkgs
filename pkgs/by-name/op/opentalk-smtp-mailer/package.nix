{
  lib,
  rustPlatform,
  fetchFromGitLab,
  versionCheckHook,
  opentalk-controller,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "opentalk-smtp-mailer";
  version = "0.13.1";

  src = fetchFromGitLab {
    domain = "gitlab.opencode.de";
    owner = "opentalk";
    repo = "smtp-mailer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RQSEn+KytOrMJKAhaKERXjXLCm+R9v65JTC/r0jOjT8=";
  };

  cargoHash = "sha256-E+HOA0Md8/iNNWkPSybJcPuUW9i0cQH9su90g8fd+jQ=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    inherit (opentalk-controller.passthru) updateScript;
  };

  meta = {
    description = "SMTP mailer service for OpenTalk to send out invites and updates on meetings";
    homepage = "https://gitlab.opencode.de/opentalk/smtp-mailer";
    changelog = "https://gitlab.opencode.de/opentalk/smtp-mailer/-/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [
      niklaskorz
    ];
    mainProgram = "opentalk-smtp-mailer";
  };
})
