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
  version = "2.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "blivet-gui";
    tag = version;
    hash = "sha256-e9YdfFHmKXsbqkzs4++nNlvqm/p6lZmc01A+g+NtuDI=";
  };

  postPatch = ''
    substituteInPlace blivetgui/gui_utils.py --replace-fail /usr/share $out/share
    substituteInPlace blivet-gui --replace-fail "pkexec blivet-gui-daemon" "pkexec $out/bin/blivet-gui-daemon"
    substituteInPlace blivet-gui --replace-fail "pkexec" "${pkexecPath}"
  '';

  nativeBuildInputs = [
    util-linux
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [ gtk3 ];

  dependencies = [
    python3.pkgs.blivet
    python3.pkgs.pyparted
    python3.pkgs.pid
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      ''${gappsWrapperArgs[@]}
      --prefix XDG_DATA_DIRS : ${adwaita-icon-theme}/share
    )
  '';

  passthru.tests.version = testers.testVersion { package = blivet-gui; };

  meta = {
    description = "GUI tool for storage configuration using blivet library";
    homepage = "https://fedoraproject.org/wiki/Blivet";
    license = lib.licenses.gpl2Plus;
    mainProgram = "blivet-gui";
    maintainers = with lib.maintainers; [ cybershadow ];
    platforms = lib.platforms.linux;
  };
}
