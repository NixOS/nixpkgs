{ lib
, python3Packages
, fetchFromGitHub
, wrapGAppsHook3
, gobject-introspection
, gtksourceview3
, libappindicator-gtk3
, libnotify
, gnome
, wmctrl
}:

python3Packages.buildPythonApplication rec {
  pname = "autokey";
  version = "0.96.0";

  src = fetchFromGitHub {
    owner = "autokey";
    repo = "autokey";
    rev = "v${version}";
    hash = "sha256-d1WJLqkdC7QgzuYdnxYhajD3DtCpgceWCAxGrk0KKew=";
  };

  # Tests appear to be broken with import errors within the project structure
  doCheck = false;

  nativeBuildInputs = [ wrapGAppsHook3 gobject-introspection ];

  buildInputs = [
    gtksourceview3
    libappindicator-gtk3
    libnotify
  ];

  propagatedBuildInputs = with python3Packages; [
    dbus-python
    pyinotify
    xlib
    pygobject3
    packaging
  ];

  runtimeDeps = [
    gnome.zenity
    wmctrl
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(''${gappsWrapperArgs[@]} --prefix PATH : ${ lib.makeBinPath runtimeDeps })
  '';

  postInstall = ''
    # remove Qt version which we currently do not support
    rm $out/bin/autokey-qt $out/share/applications/autokey-qt.desktop
  '';

  meta = {
    homepage = "https://github.com/autokey/autokey";
    description = "Desktop automation utility for Linux and X11";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ pneumaticat ];
    platforms = lib.platforms.linux;
  };
}
