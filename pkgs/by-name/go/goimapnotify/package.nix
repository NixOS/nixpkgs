{
  buildGoModule,
  fetchFromGitLab,
  lib,
  runtimeShell,
}:

buildGoModule rec {
  pname = "goimapnotify";
  version = "2.4";

  src = fetchFromGitLab {
    owner = "shackra";
    repo = "goimapnotify";
    rev = version;
    hash = "sha256-ieaj97CjoSc/qt/JebATHmiJ7RIvNUpFZjEM6mqG9Rk=";
  };

  vendorHash = "sha256-rWPXQj0XFS/Mv9ylGv09vol0kkRDNaOAEgnJvSWMvoI=";

  postPatch = ''
    for f in command.go command_test.go; do
      substituteInPlace $f --replace '"sh"' '"${runtimeShell}"'
    done
  '';

  meta = with lib; {
    description = "Execute scripts on IMAP mailbox changes (new/deleted/updated messages) using IDLE";
    homepage = "https://gitlab.com/shackra/goimapnotify";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      wohanley
      rafaelrc
    ];
    mainProgram = "goimapnotify";
  };
}
