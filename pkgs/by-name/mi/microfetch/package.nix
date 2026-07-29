{
  lib,
  rustPlatform,
  mold,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "microfetch";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "microfetch";
    tag = "${finalAttrs.version}";
    hash = "sha256-Hi9U1WqCCoXnZx8ZgT5+fT2grTdNPC73fTAn0l9kzkg=";
  };

  cargoHash = "sha256-7tN5E95uEJBUT1OMAnjkXnbSZjO23KWi8Vc3Cic9nek=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ mold ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Microscopic fetch script in Rust, for NixOS systems";
    homepage = "https://github.com/NotAShelf/microfetch";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nydragon
      NotAShelf
    ];
    mainProgram = "microfetch";
    platforms = lib.platforms.linux ++ [ "aarch64-darwin" ];
  };
})
