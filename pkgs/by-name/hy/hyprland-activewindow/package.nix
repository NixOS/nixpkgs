{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-activewindow";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "FieldOfClay";
    repo = "hyprland-activewindow";
    rev = "v${version}";
    hash = "sha256-oH3BsS0KqnNdYe7HWHlfRSiUJx+vC3IveN+mcEgwZLs=";
  };

  cargoHash = "sha256-mvmjXzHyCegZhZYVod7Hb7Ot0Vwen78fujMCRvWv/uA=";

<<<<<<< HEAD
  meta = {
    description = "Multi-monitor-aware Hyprland workspace widget helper";
    homepage = "https://github.com/FieldofClay/hyprland-activewindow";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Multi-monitor-aware Hyprland workspace widget helper";
    homepage = "https://github.com/FieldofClay/hyprland-activewindow";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      kiike
      donovanglover
    ];
    mainProgram = "hyprland-activewindow";
  };
}
