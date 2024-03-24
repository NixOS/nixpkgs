{ lib, fetchFromGitHub
, pkg-config, meson, ninja
, python3Packages
, gdk-pixbuf, glib, gobject-introspection, gtk4, libadwaita, desktop-file-utils
, libnotify
, wrapGAppsHook }:

python3Packages.buildPythonApplication rec {
  pname = "plattenalbum";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "SoongNoonien";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-rxHtcKbvwoOteSD3gC0uEp+3GCUFpKWoicznELVilpY=";
  };

  format = "other";

  nativeBuildInputs = [
    glib.dev gobject-introspection gtk4 pkg-config meson ninja wrapGAppsHook desktop-file-utils libadwaita
  ];

  buildInputs = [
    gdk-pixbuf glib libnotify
  ];

  propagatedBuildInputs = with python3Packages; [
    beautifulsoup4 distutils-extra mpd2 notify-py pygobject3 requests
  ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  # Prevent double wrapping.
  dontWrapGApps = true;
  # Otherwise wrapGAppsHook does not pick up the dependencies correctly.
  strictDeps = false;
  # There aren't any checks.
  doCheck = false;

  meta = with lib; {
    description = "A simple music browser for MPD";
    homepage = "https://github.com/SoongNoonien/plattenalbum";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ apfelkuchen6 ];
    mainProgram = "plattenalbum";
  };
}
