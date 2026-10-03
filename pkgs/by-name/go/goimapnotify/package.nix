{
  buildGoModule,
  fetchFromGitLab,
  lib,
  runtimeShell,
}:

buildGoModule (finalAttrs: {
  pname = "goimapnotify";
  version = "2.5.8";

  src = fetchFromGitLab {
    owner = "shackra";
    repo = "goimapnotify";
    tag = finalAttrs.version;
    hash = "sha256-3UXpZOTVSDrxkRCFkeUoJApYoy4g2tg19BxIPZ5KT0Y=";
  };

  vendorHash = null;

  postPatch = ''
    for f in internal/util/command.go internal/util/command_test.go; do
      substituteInPlace $f --replace-fail '"sh"' '"${runtimeShell}"'
    done
  '';

  meta = {
    description = "Execute scripts on IMAP mailbox changes (new/deleted/updated messages) using IDLE";
    homepage = "https://gitlab.com/shackra/goimapnotify";
    changelog = "https://gitlab.com/shackra/goimapnotify/-/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      wohanley
      rafaelrc
    ];
    mainProgram = "goimapnotify";
  };
})
