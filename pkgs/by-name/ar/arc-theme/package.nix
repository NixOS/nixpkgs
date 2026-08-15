{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
  inkscape,
  meson,
  ninja,
  python3,
  sassc,
  makeFontsConf,
  cinnamon,
  gnome-shell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "arc-theme";
  version = "20221218";

  src = fetchFromGitHub {
    owner = "jnsh";
    repo = "arc-theme";
    tag = finalAttrs.version;
    hash = "sha256-7VmqsUCeG5GwmrVdt9BJj0eZ/1v+no/05KwGFb7E9ns=";
  };

  nativeBuildInputs = [
    glib # for glib-compile-resources
    inkscape
    meson
    ninja
    python3
    sassc
  ];

  postPatch = ''
    patchShebangs meson/install-file.py
  '';

  preBuild = ''
    # Shut up inkscape's warnings about creating profile directory
    export HOME="$TMPDIR"
  '';

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  mesonFlags = [
    # Exclude gtk2 since it's no longer supported
    "-Dthemes=cinnamon,gnome-shell,gtk3,gtk4,metacity,plank,unity,xfwm"
    # "-Dvariants=light,darker,dark,lighter"
    "-Dcinnamon_version=${cinnamon.version}"
    "-Dgnome_shell_version=${gnome-shell.version}"
    # You will need to patch gdm to make use of this.
    "-Dgnome_shell_gresource=true"
  ];

  meta = {
    description = "Flat theme with transparent elements for GTK 3, GTK 2 and Gnome Shell";
    homepage = "https://github.com/jnsh/arc-theme";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      simonvandel
      romildo
    ];
  };
})
