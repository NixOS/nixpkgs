{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kanban";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "fulsomenko";
    repo = "kanban";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w1NoWgaUBny//3t1S5z/juPOYFomwJKtTq/M4qKoNv0=";
  };

  GIT_COMMIT_HASH = finalAttrs.src.rev;

  cargoHash = "sha256-N+c2jnJ7a+Nh2UibkaOByh4tKDX52VovYIpeHTpawXo=";

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
