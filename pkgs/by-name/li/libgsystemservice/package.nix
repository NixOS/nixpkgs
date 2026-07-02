{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  glib,
  polkit,
  gobject-introspection,
  gi-docgen,
  vala,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgsystemservice";
  version = "0.3.0";

  strictDeps = true;
  __structuredAttrs = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "pwithnall";
    repo = "libgsystemservice";
    rev = finalAttrs.version;
    hash = "sha256-e7Wq/KCY/06bp+Ub8aK3LmJrKvj+UWbh0so6EatG8OQ=";
  };

  mesonFlags = [
    "-Dgtk_doc=false"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    gi-docgen
    vala
  ];

  buildInputs = [
    polkit
    systemd
  ];

  propagatedBuildInputs = [
    glib
  ];

  meta = {
    description = "LibGSystemService";
    homepage = "https://gitlab.gnome.org/pwithnall/libgsystemservice";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ tbutter ];
    platforms = lib.platforms.unix;
  };
})
