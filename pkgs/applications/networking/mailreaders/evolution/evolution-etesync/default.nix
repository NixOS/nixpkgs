{ lib
, stdenv
, fetchFromGitLab
, gnome
, cmake
, gettext
, intltool
, pkg-config
, evolution-data-server
, evolution
, sqlite
, gtk3
, webkitgtk
, libgdata
, libmspack
, libetebase
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "evolution-etesync";
  version = "1.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "evolution-etesync";
    rev = version;
    sha256 = "sha256-J6yRjj2FINXyILb/d0L9MMm7cIYmYPiMB6YMMxzT/Tw=";
  };

  nativeBuildInputs = [
    cmake
    gettext
    intltool
    pkg-config
    autoPatchelfHook
  ];

  buildInputs = [
    evolution-data-server
    evolution
    sqlite
    libgdata
    gtk3
    webkitgtk
    libmspack
    libetebase
  ];

  cmakeFlags = [
    # don't try to install into ${evolution}
    "-DFORCE_INSTALL_PREFIX=ON"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "evolution-etesync";
    };
  };

  meta = with lib; {
    description = "EteSync plugin for Evolution";
    homepage = "https://gitlab.gnome.org/GNOME/evolution-etesync";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ pacman99 ];
    platforms = platforms.linux;
  };
}
