{
  lib,
  stdenv,
  fetchFromGitLab,
  desktop-file-utils,
  gsettings-desktop-schemas,
  glib,
  gtk3,
  libgda,
  libxml2,
  libxslt,
  makeWrapper,
  meson,
  ninja,
  pkg-config,
  shared-mime-info,
}:

stdenv.mkDerivation rec {
  pname = "planner";
  version = "0.14.92";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "planner";
    rev = version;
    hash = "sha256-2LmNeyZURVtA52Vosyn44wT8zSaJn8tR+8sPM9atAwM=";
  };

  postPatch = ''
    patchShebangs \
      meson_post_install.sh \
      tools/strip_trailing_white_space.sh \
      tests/python/task-test.py
  '';

  nativeBuildInputs = [
    desktop-file-utils
    makeWrapper
    meson
    ninja
    pkg-config
    shared-mime-info
  ];

  buildInputs = [
    libgda
    libxml2
    libxslt
    glib
    gsettings-desktop-schemas
    gtk3
  ];

  postInstall = ''
    wrapProgram $out/bin/planner \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share/gsettings-schemas/planner-${version}"
  '';

  meta = {
    description = "Project management tool for the GNOME desktop";
    mainProgram = "planner";
    homepage = "https://gitlab.gnome.org/World/planner";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ amiloradovsky ];
    platforms = lib.platforms.unix;
  };
}
