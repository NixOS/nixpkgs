{ lib
, buildPythonApplication
, copyDesktopItems
, fetchPypi
, makeDesktopItem
, flask
, jellyfin-apiclient-python
, jinja2
, mpv
, pillow
, pydantic
, pyqtwebengine
, pystray
, python-mpv-jsonipc
, pywebview
, qt5
, tkinter
, werkzeug
}:

buildPythonApplication rec {
  pname = "jellyfin-mpv-shim";
  version = "1.10.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QMyb69S8Ln4X0oUuLpL6vtgxJwq8f+Q4ReNckrN4E+E=";
  };

  propagatedBuildInputs = [
    jellyfin-apiclient-python
    mpv
    pillow
    pydantic
    python-mpv-jsonipc

    # gui dependencies
    pystray
    tkinter

    # display_mirror dependencies
    jinja2
    pywebview

    # desktop dependencies
    flask
    pyqtwebengine
    werkzeug
  ];

  nativeBuildInputs = [
    copyDesktopItems
    qt5.wrapQtAppsHook
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Jellyfin Desktop";
      exec = "jellyfin-desktop";
      icon = "jellyfin-desktop";
      desktopName = "jellyfin-desktop";
      comment = "MPV-based desktop and cast client for Jellyfin";
      genericName = "MPV-based desktop and cast client for Jellyfin";
      categories = "Video;AudioVideo;TV;Player";
    })
  ];

  # override $HOME directory:
  #   error: [Errno 13] Permission denied: '/homeless-shelter'
  #
  # remove jellyfin_mpv_shim/win_utils.py:
  #   ModuleNotFoundError: No module named 'win32gui'
  preCheck = ''
    export HOME=$TMPDIR

    rm jellyfin_mpv_shim/win_utils.py
  '';

  postPatch = ''
    substituteInPlace jellyfin_mpv_shim/conf.py \
      --replace "check_updates: bool = True" "check_updates: bool = False" \
      --replace "notify_updates: bool = True" "notify_updates: bool = False"
  '';

  postInstall = ''
    mkdir -p $out/share/pixmaps
    cp jellyfin_mpv_shim/integration/jellyfin-256.png $out/share/pixmaps/jellyfin-desktop.png
  '';

  postFixup = ''
    wrapQtApp $out/bin/jellyfin-desktop
    wrapQtApp $out/bin/jellyfin-mpv-desktop
  '';

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "jellyfin_mpv_shim" ];

  meta = with lib; {
    homepage = "https://github.com/jellyfin/jellyfin-desktop";
    description = "Allows casting of videos to MPV via the jellyfin mobile and web app";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jojosch ];
  };
}
