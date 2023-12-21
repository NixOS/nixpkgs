{ lib
, fetchFromGitHub
, python3
, gtk3
, wrapGAppsHook
, glibcLocales
, gobject-introspection
, gettext
, pango
, gdk-pixbuf
, atk
, fluxbox
}:

python3.pkgs.buildPythonApplication rec {
  pname = "fluxboxlauncher";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "mothsart";
    repo = "fluxboxlauncher";
    rev = "0.2.1";
    sha256 = "024h1dk0bhc5s4dldr6pqabrgcqih9p8cys5lqgkgz406y4vyzvf";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
    pango
    gdk-pixbuf
    atk
    gettext
  ];

  buildInputs = [
    glibcLocales
    gtk3
    python3
    fluxbox
  ];

  makeWrapperArgs = [ "--set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive"
                      "--set CHARSET en_us.UTF-8" ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
  ];

  meta = with lib; {
    description = "A Gui editor (gtk) to configure applications launching on a fluxbox session";
    homepage = "https://github.com/mothsART/fluxboxlauncher";
    maintainers = with maintainers; [ mothsart ];
    license = licenses.bsdOriginal;
    platforms = platforms.linux;
  };
}
