{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  sassc,
  gnome-shell,
  gnome-themes-extra,
  gdk-pixbuf,
  librsvg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "materia-theme";
  version = "20210322";

  src = fetchFromGitHub {
    owner = "nana-4";
    repo = "materia-theme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dHcwPTZFWO42wu1LbtGCMm2w/YHbjSUJnRKcaFllUbs=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];

  buildInputs = [
    gnome-themes-extra
    gdk-pixbuf
    librsvg
  ];

  mesonFlags = [
    (lib.mesonOption "gnome_shell_version" (lib.versions.majorMinor gnome-shell.version))
  ];

  meta = {
    description = "Material Design theme for GNOME/GTK based desktop environments";
    homepage = "https://github.com/nana-4/materia-theme";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.marrobHD ];
  };
})
