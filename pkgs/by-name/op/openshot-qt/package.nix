{
  lib,
  fetchFromGitHub,
  doxygen,
  gtk3,
  libopenshot,
  wrapGAppsHook3,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "openshot-qt";
  version = "3.5.1";
  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "openshot-qt";
    rev = "930ff919762570eaf35a879574da8f8da9f196be";
    hash = "sha256-o0BPEzkEAyoZkPkiR9G8i2nANgDFI4wjD5b9hGOqB0c=";
  };
  format = "setuptools";

  outputs = [ "out" ]; # "lib" can't be split

  nativeBuildInputs = [
    doxygen
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
  ];

  propagatedBuildInputs = with python3Packages; [
    httplib2
    libopenshot
    pyzmq
    requests
    sip
    pyside6
  ];

  strictDeps = true;

  doCheck = false;

  dontWrapGApps = true;
  dontWrapQtApps = true;

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
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "openshot-qt";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
