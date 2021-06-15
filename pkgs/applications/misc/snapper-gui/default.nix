{ lib, fetchFromGitHub, python3, python3Packages
, gnome, gtk3, wrapGAppsHook, gtksourceview3, snapper
, gobject-introspection
}:

python3Packages.buildPythonApplication rec {
  pname = "snapper-gui";
  version = "2020-10-20";

  src = fetchFromGitHub {
    owner = "ricardomv";
    repo = pname;
    rev = "f0c67abe0e10cc9e2ebed400cf80ecdf763fb1d1";
    sha256 = "13j4spbi9pxg69zifzai8ifk4207sn0vwh6vjqryi0snd5sylh7h";
  };

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs = [
    python3
    gobject-introspection
    gnome.adwaita-icon-theme
  ];

  doCheck = false; # it doesn't have any tests

  propagatedBuildInputs = with python3Packages; [
    gtk3
    dbus-python
    pygobject3
    setuptools
    gtksourceview3
    snapper
  ];

  meta = with lib; {
    description = "Graphical interface for snapper";
    longDescription = ''
      A graphical user interface for the tool snapper for Linux filesystem
      snapshot management. It can compare snapshots and revert differences between snapshots.
      In simple terms, this allows root and non-root users to view older versions of files
      and revert changes. Currently works with btrfs, ext4 and thin-provisioned LVM volumes.
    '';
    homepage = "https://github.com/ricardomv/snapper-gui";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ahuzik ];
  };
}
