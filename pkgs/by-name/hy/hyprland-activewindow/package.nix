{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-activewindow";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "FieldOfClay";
    repo = "hyprland-activewindow";
    rev = "v${version}";
    hash = "sha256-kRxA2DLbbABPJFwv/L7yeNJ8eqNUbuV6U/PB5iJNoAw=";
  };

  cargoHash = "sha256-s3Ho0+OzuLuWqFvaBu9NLXoasByHSuun9eJGAAISOJc=";

  meta = with lib; {
    description = "A multi-monitor-aware Hyprland workspace widget helper";
    homepage = "https://github.com/FieldofClay/hyprland-activewindow";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      kiike
      donovanglover
    ];
    mainProgram = "hyprland-activewindow";
  };
}
