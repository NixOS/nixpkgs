{ lib
, buildPythonApplication
, fetchPypi
, jellyfin-apiclient-python
, jinja2
, mpv
, pillow
, pystray
, python-mpv-jsonipc
, pywebview
, tkinter
}:

buildPythonApplication rec {
  pname = "jellyfin-mpv-shim";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JiSC6WjrLsWk3/m/EHq7KNXaJ6rqT2fG9TT1jPvYlK0=";
  };

  propagatedBuildInputs = [
    jellyfin-apiclient-python
    mpv
    pillow
    python-mpv-jsonipc

    # gui dependencies
    pystray
    tkinter

    # display_mirror dependencies
    jinja2
    pywebview
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

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "jellyfin_mpv_shim" ];

  meta = with lib; {
    homepage = "https://github.com/jellyfin/jellyfin-mpv-shim";
    description = "Allows casting of videos to MPV via the jellyfin mobile and web app";
    longDescription = ''
      Jellyfin MPV Shim is a client for the Jellyfin media server which plays media in the
      MPV media player. The application runs in the background and opens MPV only
      when media is cast to the player. The player supports most file formats, allowing you
      to prevent needless transcoding of your media files on the server. The player also has
      advanced features, such as bulk subtitle updates and launching commands on events.
    '';
    license = with licenses; [
      # jellyfin-mpv-shim
      gpl3Only
      mit

      # shader-pack licenses (github:iwalton3/default-shader-pack)
      # KrigBilateral, SSimDownscaler, NNEDI3
      gpl3Plus
      # Anime4K, FSRCNNX
      mit
      # Static Grain
      unlicense
    ];
    maintainers = with maintainers; [ jojosch ];
  };
}
