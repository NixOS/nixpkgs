{ lib
, fetchFromGitHub
, meson
, ninja
, python3
, gettext
, gtk3
, optipng
, pngquant
, jpegoptim
, libwebp
, glib
, wrapGAppsHook
, gobject-introspection
, pango
, appstream-glib
, pkg-config
, desktop-file-utils
}:

python3.pkgs.buildPythonApplication rec {

  pname = "curtail";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "Huluti";
    repo = "Curtail";
    rev = version;
    sha256 = "sha256-tNk+KI+DEMR63zfcBpfPTxAFKzvGWvpa9erK9SAAtPc=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    appstream-glib
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    appstream-glib
    gettext
    glib
    gobject-introspection
    gtk3
    jpegoptim
    libwebp
    optipng
    pango
    pngquant
  ];

  propagatedBuildInputs = [ python3.pkgs.pygobject3 ];

  # This is needed to let gobject-introspection’s setup hook run
  # Disabling this breaks icon themes (at least)
  strictDeps = false;

  # Tells the Python builder to use normal building methods instead of using a setup.py
  format = "other";

  preInstall = ''
    patchShebangs --build /build/source/build-aux/meson/postinstall.py
  '';

  meta = with lib; {
    description = "Simple & useful image compressor";
    homepage = "https://github.com/Huluti/Curtail";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ anselschmueler ];
  };
}
