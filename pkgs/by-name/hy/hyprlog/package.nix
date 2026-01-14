{
  lib,
  rustPlatform,
  fetchFromGitHub,
  finalAttrs,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprlog";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "gusjengis";
    repo = "hyprlog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nHTUa7UpdlsO4TUrQfGo82KlgXkG3RxC9iyfiDOmOyQ=";
  };

  cargoHash = "sha256-nHTUa7UpdlsO4TUrQfGo82KlgXkG3RxC9iyfiDOmOyQ=";

  meta = {
    description = "Hyprland focus/activity logger";
    homepage = "https://github.com/gusjengis/hyprlog";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ gusjengis ];
    mainProgram = "hyprlog";
    platforms = platforms.linux;
  };
}
