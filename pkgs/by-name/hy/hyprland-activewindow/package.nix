{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprland-activewindow";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "FieldOfClay";
    repo = "hyprland-activewindow";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8bwZHagwROdIF6jvEf9AGhsXHgSypfldqxhVCaPlnY0=";
  };

  cargoHash = "sha256-20unJ0aZ2KnT74dvgs/oiXZ6mZET0aFfxRjDhzG/1Gk=";

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
