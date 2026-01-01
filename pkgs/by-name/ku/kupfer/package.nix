{
  lib,
  fetchurl,
  intltool,
  python3Packages,
  gobject-introspection,
  gtk3,
  itstool,
  libwnck,
  keybinder3,
  desktop-file-utils,
  shared-mime-info,
  wrapGAppsHook3,
  wafHook,
  bash,
  dbus,
}:

with python3Packages;

buildPythonApplication rec {
  pname = "kupfer";
<<<<<<< HEAD
  version = "329";
=======
  version = "328";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  format = "other";

  src = fetchurl {
    url = "https://github.com/kupferlauncher/kupfer/releases/download/v${version}/kupfer-v${version}.tar.xz";
<<<<<<< HEAD
    sha256 = "sha256-9kX30EYYkb7s/T5VfpyqZQ5F1wpvtWfTT790LZmVqq0=";
=======
    sha256 = "sha256-1oPvcho54uXCvov4eTZTjObL0EecimfxVOxl+bOU6do=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    intltool
    # For setup hook
    gobject-introspection
    wafHook
    itstool # for help pages
    desktop-file-utils # for update-desktop-database
    shared-mime-info # for update-mime-info
    docutils # for rst2man
    dbus # for detection of dbus-send during build
  ];
  buildInputs = [
    libwnck
    keybinder3
    bash
  ];
  propagatedBuildInputs = [
    pygobject3
    gtk3
    pyxdg
    dbus-python
    pycairo
  ];

  postInstall = ''
    gappsWrapperArgs+=(
      "--prefix" "PYTHONPATH" : "${makePythonPath propagatedBuildInputs}"
      "--set" "PYTHONNOUSERSITE" "1"
    )
  '';

  doCheck = false; # no tests

<<<<<<< HEAD
  meta = {
    description = "Smart, quick launcher";
    homepage = "https://kupferlauncher.github.io/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ cobbal ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Smart, quick launcher";
    homepage = "https://kupferlauncher.github.io/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ cobbal ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
