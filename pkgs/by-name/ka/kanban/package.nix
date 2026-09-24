{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kanban";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "fulsomenko";
    repo = "kanban";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qvjUeYNJ4ODO5dxAaWuWIIpqmFjE6t3ZeuSvZcp5xaI=";
  };

  env.GIT_COMMIT_HASH = finalAttrs.src.rev;

  cargoHash = "sha256-YO1brjDNQxt155VtxIpniAdhEvv22vQlk8CUMz2f9Qs=";

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
