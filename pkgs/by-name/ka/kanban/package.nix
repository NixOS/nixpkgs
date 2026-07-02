{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kanban";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "fulsomenko";
    repo = "kanban";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6L+f4+A9mRZch7/D1koCMHrkciusKcoZhYJICEDU4b8=";
  };

  env.GIT_COMMIT_HASH = finalAttrs.src.rev;

  cargoHash = "sha256-NMFZW+LC5YYqbXCmgbmUyAx8O+M7o1TKigOC978k0/o=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based project management solution";
    longDescription = ''
      A terminal-based kanban/project management tool inspired by lazygit,
      built with Rust. Features include file persistence, keyboard-driven
      navigation, multi-select capabilities, and sprint management.
    '';
    homepage = "https://kanban.yoon.se";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fulsomenko ];
    mainProgram = "kanban";
    platforms = lib.platforms.all;
  };
})
