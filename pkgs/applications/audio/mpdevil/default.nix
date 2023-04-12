{ lib, fetchFromGitHub
, pkg-config, meson ,ninja
, python3Packages
, gdk-pixbuf, glib, gobject-introspection, gtk3
, libnotify
, wrapGAppsHook }:

python3Packages.buildPythonApplication rec {
  pname = "mpdevil";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "SoongNoonien";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zLCL64yX7i/mtUf8CkgrSwb6zZ7vhR1Dw8eUH/vgFT4=";
  };

  format = "other";

  nativeBuildInputs = [
    glib.dev gobject-introspection gtk3 pkg-config meson ninja wrapGAppsHook
  ];

  buildInputs = [
    gdk-pixbuf glib libnotify
  ];

  propagatedBuildInputs = with python3Packages; [
    beautifulsoup4 distutils_extra mpd2 notify-py pygobject3 requests
  ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  # Prevent double wrapping.
  dontWrapGApps = true;
  # Otherwise wrapGAppsHook do not pick up the dependencies correctly.
  strictDeps = false;
  # There aren't any checks.
  doCheck = false;

  meta = with lib; {
    description = "A simple music browser for MPD";
    homepage = "https://github.com/SoongNoonien/mpdevil";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ apfelkuchen6 ];
  };
}
