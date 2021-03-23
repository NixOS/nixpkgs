{ lib, fetchFromGitHub
, python3Packages
, gdk-pixbuf, glib, gobject-introspection, gtk3
, intltool
, wrapGAppsHook }:

python3Packages.buildPythonApplication rec {
  pname = "mpdevil";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "SoongNoonien";
    repo = pname;
    rev = "v${version}";
    sha256 = "0l7mqv7ys05al2hds4icb32hf14fqi3n7b0f5v1yx54cbl9cqfap";
  };

  nativeBuildInputs = [
    glib.dev gobject-introspection gtk3 intltool wrapGAppsHook
  ];

  buildInputs = [
    gdk-pixbuf glib
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
    maintainers = with maintainers; [ bloomvdomino ];
  };
}
