{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  flex,
  itstool,
  wrapGAppsHook3,
  desktop-file-utils,
  exiv2,
  libgsf,
  taglib,
  poppler,
  samba,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-commander";
  version = "1.18.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-commander";
    tag = finalAttrs.version;
    hash = "sha256-4l+hw9zPYhkaOpXMEnn4vXF1q0JLE0CB4oRGr2iXqtw=";
  };

  # hard-coded schema paths
  postPatch = ''
    substituteInPlace src/gnome-cmd-data.cc plugins/fileroller/file-roller-plugin.cc \
      --replace-fail \
        '/share/glib-2.0/schemas' \
        '/share/gsettings-schemas/${finalAttrs.finalPackage.name}/glib-2.0/schemas'
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    flex
    itstool
    wrapGAppsHook3
    desktop-file-utils
  ];

  buildInputs = [
    exiv2
    libgsf
    taglib
    poppler
    samba
  ];

  mesonFlags = [ (lib.mesonEnable "tests" finalAttrs.finalPackage.doCheck) ];

  checkInputs = [ gtest ];

  doCheck = false; # gtest requires C/C++17 but the project is written in C/C++11

  meta = {
    description = "Fast and powerful twin-panel file manager for the Linux desktop";
    homepage = "https://gcmd.github.io";
    license = lib.licenses.gpl2Plus;
    mainProgram = "gnome-commander";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
