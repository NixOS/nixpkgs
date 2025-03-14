{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "minecraft-server-hibernation";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "gekware";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-b6LeqjIraIasHBpaVgy8esl4NV8rdBrfO7ewgeIocS8=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags =
    let
      skippedTests = [
        # Disable tests requiring network access
        "Test_getPing"
        "Test_getReqType"
        "Test_QueryBasic"
        "Test_QueryFull"
      ];
    in
    [
      "-skip"
      "${builtins.concatStringsSep "|" skippedTests}"
    ];

  meta = with lib; {
    description = "Autostart and stop minecraft-server when players join/leave";
    mainProgram = "msh";
    homepage = "https://github.com/gekware/minecraft-server-hibernation";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ squarepear ];
  };
}
