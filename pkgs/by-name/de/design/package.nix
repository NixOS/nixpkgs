{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapGAppsHook4,
  appstream-glib,
  blueprint-compiler,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  glib,
  gjs,
  libadwaita,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "design";
  version = "48-alpha1";

  src = fetchFromGitHub {
    owner = "dubstar-04";
    repo = "Design";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-xLARmvqJUxVjHHeak/BrpfIe18KCy9++8HRjOFjwE7I=";
  };

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    gjs
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    libadwaita
  ];

  # Use a symlink here so that the basename isn't changed by the wrapper which is used to decide the resource path.
  postInstall = ''
    mv $out/bin/io.github.dubstar_04.design $out/share/design/
    ln -s $out/share/design/io.github.dubstar_04.design $out/bin
  '';

  meta = {
    homepage = "https://github.com/dubstar-04/Design";
    description = "2D CAD For GNOME";
    maintainers = with lib.maintainers; [ linsui ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "io.github.dubstar_04.design";
  };
})
