{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hyprmon";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "erans";
    repo = "hyprmon";
    rev = "v${version}";
    hash = "sha256-jZUtdOMmpd75CyjaXdrqXcYxcQ9q7G2YGBHoUUvycX8=";
  };

  vendorHash = "sha256-THfdsr8jSvbcV1C2C2IJNvjeeonSZDfmCo6Ws2WreBA=";

  meta = with lib; {
    description = "TUI monitor configuration tool for Hyprland with visual layout, drag-and-drop, and profile management";
    homepage = "https://github.com/erans/hyprmon";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onatustun ];
    mainProgram = "hyprmon";
  };
}
