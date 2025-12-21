{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kanban";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "fulsomenko";
    repo = "kanban";
    rev = "6557b7343975b73e76f1289842597fc41c4900ba";
    hash = "sha256-YJ9dUfZO8bWXexfX6Y3eTOW72qogVrGOLCVwaRoHlAA=";
  };

  GIT_COMMIT_HASH = finalAttrs.src.rev;

  cargoHash = "sha256-Q/o5MHjVRrJpfhkzNNJ6j4oASV5wDg/0Zi43zPlp5p8=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based project management solution";
    longDescription = ''
      A terminal-based kanban/project management tool inspired by lazygit,
      built with Rust. Features include file persistence, keyboard-driven
      navigation, multi-select capabilities, and sprint management.
    '';
    homepage = "https://github.com/fulsomenko/kanban";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fulsomenko ];
    mainProgram = "kanban";
    platforms = lib.platforms.all;
  };
})
