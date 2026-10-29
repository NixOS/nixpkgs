{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprland-activewindow";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "FieldOfClay";
    repo = "hyprland-activewindow";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oH3BsS0KqnNdYe7HWHlfRSiUJx+vC3IveN+mcEgwZLs=";
  };

  cargoHash = "sha256-mvmjXzHyCegZhZYVod7Hb7Ot0Vwen78fujMCRvWv/uA=";

  meta = {
    description = "Multi-monitor-aware Hyprland workspace widget helper";
    homepage = "https://github.com/FieldofClay/hyprland-activewindow";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      kiike
      donovanglover
    ];
    mainProgram = "hyprland-activewindow";
  };
})
