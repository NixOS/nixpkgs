{
  buildGoModule,
  fetchFromGitLab,
  lib,
  runtimeShell,
}:

buildGoModule (finalAttrs: {
  pname = "goimapnotify";
  version = "2.5.4";

  src = fetchFromGitLab {
    owner = "shackra";
    repo = "goimapnotify";
    tag = finalAttrs.version;
    hash = "sha256-6hsepgXdG+BSSKTVics2459qUxYPIHKNqm2yq8UJXks=";
  };

  vendorHash = "sha256-5cZzaCoOR1R7iST0q3GaJbYIbKKEigeWqhp87maOL04=";

  postPatch = ''
    for f in command.go command_test.go; do
      substituteInPlace $f --replace '"sh"' '"${runtimeShell}"'
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
