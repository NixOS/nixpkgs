{ lib
, python3Packages
, fetchFromGitHub
, wrapGAppsHook
, gobject-introspection
, gtksourceview3
, libappindicator-gtk3
, libnotify
}:

python3Packages.buildPythonApplication rec {
  pname = "autokey";
  version = "0.95.10";

  src = fetchFromGitHub {
    owner = "autokey";
    repo = "autokey";
    rev = "v${version}";
    sha256 = "0f0cqfnb49wwdy7zl2f2ypcnd5pc8r8n7z7ssxkq20d4xfxlgamr";
  };

  # Tests appear to be broken with import errors within the project structure
  doCheck = false;

  nativeBuildInputs = [ wrapGAppsHook gobject-introspection ];

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
  ];

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
