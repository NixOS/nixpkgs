{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kanban";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "fulsomenko";
    repo = "kanban";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HJb52Qskyqzjcjp6SlM81OSL2GtpMEYxuuYWy9yLxYQ=";
  };

  env.GIT_COMMIT_HASH = finalAttrs.src.rev;

  cargoHash = "sha256-o+C8TsE/5myoKGhSIWG+OIHliTOM5dQBY1E3a5KFcxs=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based project management solution";
    longDescription = ''
      A terminal-based kanban/project management tool inspired by lazygit,
      built with Rust. Features include file persistence, keyboard-driven
      navigation, multi-select capabilities, and sprint management.
    '';
    homepage = "https://kanban.rs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fulsomenko ];
    mainProgram = "kanban";
    platforms = lib.platforms.all;
  };
})
