{
  lib,
  stdenv,
  fetchurl,
  bash,
  gnome,
  meson,
  python3,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "mm-common";
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://gnome/sources/mm-common/${lib.versions.majorMinor version}/mm-common-${version}.tar.xz";
    sha256 = "SUq/zngUGCWbHp2IiMc69N5LbzvjbMddm6qLqg8qejk=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    python3
    ninja
  ];

  # for shebangs
  buildInputs = [
    python3
    bash
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = {
    description = "Common build files of GLib/GTK C++ bindings";
    longDescription = ''
      The mm-common module provides the build infrastructure and utilities
      shared among the GNOME C++ binding libraries. It is only a required
      dependency for building the C++ bindings from the gnome.org version
      control repository. An installation of mm-common is not required for
      building tarball releases, unless configured to use maintainer-mode.
    '';
    homepage = "https://www.gtkmm.org";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
}
