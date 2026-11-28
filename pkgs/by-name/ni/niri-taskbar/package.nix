{
  lib,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
  pango,
  gdk-pixbuf,
  atk,
  gtk3,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "niri-taskbar";
  version = "0.4.0+niri.25.11";

  src = fetchFromGitHub {
    owner = "lawngnome";
    repo = "niri-taskbar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aE5v94AA6bC0CP8pv/SPBxGKpkH+GxR/p7hTKXlvk3E=";
  };

  cargoHash = "sha256-WRc1+ZVhiIfmLHaczAPq21XudI08CgVhlIhVcf0rmSw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    pango
    gdk-pixbuf
    atk
    gtk3
  ];

  meta = {
    description = "A taskbar for the niri compositor";
    homepage = "https://github.com/lawngnome/niri-taskbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luochen1990 ];
    platforms = lib.platforms.linux;
  };
})
