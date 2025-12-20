{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kanban";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "fulsomenko";
    repo = "kanban";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g7VCPwlM8TkuYA07VvsWcwc6Z2DAHPzubpngDj8pUYQ=";
  };

  cargoHash = "sha256-naWuk9vYwtOKEMYOHMhtu7uKt4xGiNffEUp6FrVuFTM=";

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
