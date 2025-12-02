{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gocheat";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Achno";
    repo = "gocheat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9Xw1GVfqk0Se8pLx3vzqR+f9GgX4LDo/H3iq1fzoTRs=";
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
