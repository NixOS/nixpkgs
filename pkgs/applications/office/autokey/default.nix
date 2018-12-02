{ lib, python3Packages, fetchFromGitHub, wrapGAppsHook, gobject-introspection
, gnome3, libappindicator-gtk3, libnotify }:

python3Packages.buildPythonApplication rec {
  name = "autokey-${version}";
  version = "0.94.1";

  src = fetchFromGitHub {
    owner = "autokey";
    repo = "autokey";
    rev = "v${version}";
    sha256 = "1syxyciyxzs0khbfs9wjgj03q967p948kipw27j1031q0b5z3jxr";
  };

  # Arch requires a similar work around—see
  # https://aur.archlinux.org/packages/autokey-py3/?comments=all
  patches = [ ./remove-requires-dbus-python.patch ];

  # Tests appear to be broken with import errors within the project structure
  doCheck = false;

  # Note: no dependencies included for Qt GUI because Qt ui is poorly
  # maintained—see https://github.com/autokey/autokey/issues/51

  buildInputs = [ wrapGAppsHook gobject-introspection gnome3.gtksourceview
    libappindicator-gtk3 libnotify ];

  propagatedBuildInputs = with python3Packages; [
    dbus-python pyinotify xlib pygobject3 ];

  meta = {
    homepage = https://github.com/autokey/autokey;
    description = "Desktop automation utility for Linux and X11";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ pneumaticat ];
    platforms = lib.platforms.linux;
  };
}
