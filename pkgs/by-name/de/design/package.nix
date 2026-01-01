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

stdenv.mkDerivation rec {
  pname = "design";
<<<<<<< HEAD
  version = "48-alpha1";
=======
  version = "46-alpha1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "dubstar-04";
    repo = "Design";
    tag = "v${version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = "sha256-xLARmvqJUxVjHHeak/BrpfIe18KCy9++8HRjOFjwE7I=";
=======
    hash = "sha256-Q4R/Ztu4w8IRvq15xNXN/iP/6hIHe/W+me1jROGpYc8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
}
