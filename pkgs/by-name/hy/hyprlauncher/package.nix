{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  glib,
  pango,
  gtk4,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprlauncher";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "hyprutils";
    repo = "hyprlauncher";
    rev = "refs/tags/v${version}";
    hash = "sha256-SxsCfEHrJpFSi2BEFFqmJLGJIVzkluDU6ogKkTRT9e8=";
  };

  cargoHash = "sha256-MENreS+DXdJIurWUqHbeb0cCJlRnjjW1bmGdg0QoxlQ=";

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];
  buildInputs = [
    glib
    pango
    gtk4
  ];

  meta = {
    description = "GUI for launching applications, written in Rust";
    homepage = "https://github.com/hyprutils/hyprlauncher";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ arminius-smh ];
    platforms = lib.platforms.linux;
    mainProgram = "hyprlauncher";
  };
}
