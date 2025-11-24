{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3,
  python3Packages,
  adwaita-icon-theme,
  gtk3,
  wrapGAppsHook3,
  gtksourceview3,
  snapper,
  gobject-introspection,
}:

python3Packages.buildPythonApplication {
  pname = "snapper-gui";
  version = "0.1-unstable-2022-06-26";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ricardomv";
    repo = "snapper-gui";
    rev = "191575084a4e951802c32a4177dc704cf435883a";
    sha256 = "sha256-uy1oLJx4ERGc8OHzmPpnJX81jPB9ztrA0qbmm1UcmTY=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    python3
    adwaita-icon-theme
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

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = with lib; {
    description = "Graphical interface for snapper";
    mainProgram = "snapper-gui";
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
