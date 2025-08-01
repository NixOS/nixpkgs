{
  buildGoModule,
  fetchFromGitLab,
  lib,
  runtimeShell,
}:

buildGoModule rec {
  pname = "goimapnotify";
  version = "2.5.3";

  src = fetchFromGitLab {
    owner = "shackra";
    repo = "goimapnotify";
    tag = version;
    hash = "sha256-sA2fXk7/xnPl8ogrF00fiRCZvhFoHWjNlugL6gTGHk0=";
  };

  vendorHash = "sha256-5cZzaCoOR1R7iST0q3GaJbYIbKKEigeWqhp87maOL04=";

  postPatch = ''
    for f in command.go command_test.go; do
      substituteInPlace $f --replace '"sh"' '"${runtimeShell}"'
    done
  '';

  meta = with lib; {
    description = "Execute scripts on IMAP mailbox changes (new/deleted/updated messages) using IDLE";
    homepage = "https://gitlab.com/shackra/goimapnotify";
    changelog = "https://gitlab.com/shackra/goimapnotify/-/blob/${src.tag}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      wohanley
      rafaelrc
    ];
    mainProgram = "goimapnotify";
  };
}
