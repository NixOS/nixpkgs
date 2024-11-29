{ stdenv
, lib
, fetchurl
, intltool
, pkg-config
, libwnck
, libxfce4ui
, xfce4-panel
, xfconf
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "xfce4-windowck-plugin";
  version = "0.5.1";

  src = fetchurl {
    # Use dist tarballs to avoid pulling extra deps and generating images ourselves.
    url = "mirror://xfce/src/panel-plugins/xfce4-windowck-plugin/${lib.versions.majorMinor version}/xfce4-windowck-plugin-${version}.tar.bz2";
    sha256 = "sha256-p4FEi3gemE072lmw2qsNGE1M7CJSMW9zcKxKmO/kgfQ=";
  };

  nativeBuildInputs = [
    intltool
    pkg-config
  ];

  buildInputs = [
    libwnck
    libxfce4ui
    xfce4-panel
    xfconf
  ];

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/xfce4-windowck-plugin";
    rev-prefix = "xfce4-windowck-plugin-";
  };

  meta = with lib; {
    description = "Xfce panel plugin for displaying window title and buttons";
    homepage = "https://gitlab.xfce.org/panel-plugins/xfce4-windowck-plugin";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
