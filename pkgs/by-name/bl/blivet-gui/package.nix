# Notes for using this package outside of NixOS:
# 1. --pure cannot be used (as pkexec will be used from the path,
#    and we can't use nixpkgs polkit due to lack of setuid bit)
# 2. You must prefix the blivet-gui command with "SHELL=/bin/bash"
#    (otherwise your system polkit will reject the SHEL Lfrom nixpkgs).

{
  lib,
  python3,
  fetchFromGitHub,
  gtk3,
  util-linux,
  gobject-introspection,
  adwaita-icon-theme,
  hicolor-icon-theme,
  wrapGAppsHook3,
  pkexecPath ? "pkexec",
  testers,
  blivet-gui,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "blivet-gui";
  version = "2.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = pname;
    rev = version;
    hash = "sha256-fKd2Vj8clZ6Q7bZipfN5umyMW2rBXMUnpAuDE70p67U=";
  };

  postPatch = ''
    substituteInPlace blivetgui/gui_utils.py --replace /usr/share $out/share
    substituteInPlace blivet-gui --replace "pkexec blivet-gui-daemon" "pkexec $out/bin/blivet-gui-daemon"
    substituteInPlace blivet-gui --replace "pkexec" "${pkexecPath}"
  '';

  preFixup = ''
    makeWrapperArgs+=(--prefix XDG_DATA_DIRS : ${adwaita-icon-theme}/share)
  '';

  nativeBuildInputs = [
    util-linux
    gobject-introspection
    wrapGAppsHook3
  ];

  propagatedBuildInputs = [
    gobject-introspection
    gtk3
    python3.pkgs.blivet
    python3.pkgs.pyparted
    python3.pkgs.pid
  ];

  passthru.tests.version = testers.testVersion { package = blivet-gui; };

  meta = with lib; {
    description = "GUI tool for storage configuration using blivet library";
    homepage = "https://fedoraproject.org/wiki/Blivet";
    license = licenses.gpl2Plus;
    mainProgram = pname;
    maintainers = with maintainers; [ cybershadow ];
    platforms = lib.platforms.linux;
  };
}
