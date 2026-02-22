{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "minecraft-server-hibernation";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "gekware";
    repo = "minecraft-server-hibernation";
    rev = "v${finalAttrs.version}";
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

  meta = {
    description = "Autostart and stop minecraft-server when players join/leave";
    mainProgram = "msh";
    homepage = "https://github.com/gekware/minecraft-server-hibernation";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ squarepear ];
  };
})
