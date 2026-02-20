{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  meson,
  ninja,
  pkg-config,
  cargo,
  rustc,
  wrapGAppsNoGuiHook,
  gst_all_1,
  fontconfig,
  libglycin,
  glycin-loaders,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gst-thumbnailers";
  version = "1.0.alpha.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gst-thumbnailers";
    tag = finalAttrs.version;
    hash = "sha256-LOdD8ECSK+QuXkE8jjIg5IfZSQ5FcIi3hmZ2vAaaBKI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-PIqEEijKe+wsX6idqoIB591h1Yj4mixwXDKDN4caO9I=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    fontconfig
    libglycin
    glycin-loaders
  ];

  meta = {
    description = "Generate thumbnailer for video and audio files";
    homepage = "https://gitlab.gnome.org/GNOME/gst-thumbnailers";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.aleksana ];
    platforms = lib.platforms.linux;
  };
})
