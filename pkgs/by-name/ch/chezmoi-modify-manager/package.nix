{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chezmoi-modify-manager";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "VorpalBlade";
    repo = "chezmoi_modify_manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S/KyyCHYytm/v6Bmld+JxcfmCrLaSgLBhJrz6nQlpVo=";
  };

  cargoHash = "sha256-MT/RxJS46mQBR84gwXl6SdKF3PgZ5CmyYWiX+dROBg8=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  buildInputs = [ dbus ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ "keyring" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Chezmoi addon to patch ini files with mixed settings and state";
    homepage = "https://github.com/VorpalBlade/chezmoi_modify_manager";
    changelog = "https://github.com/VorpalBlade/chezmoi_modify_manager/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ chadnorvell ];
    mainProgram = "chezmoi_modify_manager";
    platforms = lib.platforms.linux;
  };
})
