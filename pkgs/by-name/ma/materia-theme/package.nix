{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  meson,
  ninja,
  sassc,
  gnome-shell,
  gdk-pixbuf,
  librsvg,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "materia-theme";
  version = "20210322";

  src = fetchFromGitHub {
    owner = "nana-4";
    repo = "materia-theme";
    tag = "v${finalAttrs.version}";
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
    gdk-pixbuf
    librsvg
  ];

  mesonFlags = [
    (lib.mesonOption "gnome_shell_version" "40")
  ];

  # The GTK2 theme needs gtk-engine-murrine, which is no longer packaged.
  postPatch = ''
    substituteInPlace src/meson.build \
      --replace-fail "subdir('gtk-2.0')" ""
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Material Design theme for GNOME/GTK based desktop environments";
    homepage = "https://github.com/nana-4/materia-theme";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.marrobHD ];
  };
})
