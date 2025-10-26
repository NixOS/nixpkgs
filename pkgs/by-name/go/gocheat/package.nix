{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gocheat";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "Achno";
    repo = "gocheat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lG/WcFKD2xeQ0v/zJWB3XP9Hd5GgRyGiCkcC08a6oPg=";
  };

  vendorHash = "sha256-CByVf4+WWUlFGJcqt7aq5bHXiLMjdHTKvv6PQYEbLqc=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "TUI Cheatsheet for keybindings, hotkeys and more";
    homepage = "https://github.com/Achno/gocheat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      adamperkowski
      sebaguardian
    ];
    mainProgram = "gocheat";
  };
})
