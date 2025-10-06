{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "mmtui";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "SL-RU";
    repo = "mmtui";
    tag = "v${version}";
    hash = "sha256-s+50kz6OODZ0xKz8oNF2YEzk+mLZ6gXXynl8g6Uwdo4=";
  };

  cargoHash = "sha256-9F1YMepkWksTQRrkziNhLxVJnhoDH17lSKef5kOjp3Y=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/SL-RU/mmtui/releases/tag/v${version}";
    description = "TUI disk mount manager for TUI file managers";
    homepage = "https://github.com/SL-RU/mmtui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ grimmauld ];
    mainProgram = "mmtui";
    platforms = lib.platforms.linux;
  };
}
