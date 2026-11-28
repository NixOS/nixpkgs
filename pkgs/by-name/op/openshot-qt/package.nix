{
  lib,
  fetchFromGitHub,
  doxygen,
  gtk3,
  libopenshot,
  wrapGAppsHook3,
  python3Packages,
  qt6,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "openshot-qt";
  version = "3.5.1-unstable-2026-07-23";
  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "openshot-qt";
    rev = "9cd2b3f3ee9024c3496487a2de30a402515ed659";
    hash = "sha256-SoEt3tuydz+JUzhvUa7Pejxd1LYNia17YvGmVlnh48I=";
  };
  format = "setuptools";

  patches = [
    # https://github.com/OpenShot/openshot-qt/pull/6176
    ./recover-invalid-export-settings.patch
    # https://github.com/OpenShot/openshot-qt/pull/6175
    ./fix-wayland-app-id.patch
  ];

  outputs = [ "out" ]; # "lib" can't be split

  nativeBuildInputs = [
    doxygen
    wrapGAppsHook3
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    gtk3
    qt6.qtbase
    qt6.qtsvg
  ];

  propagatedBuildInputs = with python3Packages; [
    httplib2
    libopenshot
    pyzmq
    requests
    sip
    pyside6
  ];

  doCheck = false;

  dontWrapGApps = true;
  dontWrapQtApps = true;

  # Pass GTK schemas and Qt plugins to the Python application wrapper.
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  # https://github.com/OpenShot/openshot-qt/blob/930ff919762570eaf35a879574da8f8da9f196be/src/launch.py#L86
  # imports qt_api.py from its own site-packages directory
  postFixup = ''
    wrapProgram $out/bin/openshot-qt \
      --prefix PYTHONPATH : "$out/${python3Packages.python.sitePackages}/openshot_qt"
  '';

  passthru = {
    inherit libopenshot;
    inherit (libopenshot) libopenshot-audio;
  };

  meta = {
    homepage = "http://openshot.org/";
    description = "Free, open-source video editor";
    longDescription = ''
      OpenShot Video Editor is a free, open-source video editor for Linux.
      OpenShot can take your videos, photos, and music files and help you create
      the film you have always dreamed of. Easily add sub-titles, transitions,
      and effects, and then export your film to DVD, YouTube, Vimeo, Xbox 360,
      and many other common formats.
    '';
    license = lib.licenses.gpl3Plus;
    mainProgram = "openshot-qt";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
