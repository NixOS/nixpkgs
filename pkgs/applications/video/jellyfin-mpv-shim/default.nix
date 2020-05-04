{ stdenv, buildPythonApplication, fetchFromGitHub, fetchurl
, mpv, python-mpv-jsonipc, jellyfin-apiclient-python
, pillow, tkinter, pystray, jinja2, pywebview }:

buildPythonApplication rec {
  pname = "jellyfin-mpv-shim";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = pname;
    rev = "v${version}";
    sha256 = "1cnii5wj0pgqg3dqk5cm6slpbs3730x8ippps4cjbsxcsrmqjpx6";
    fetchSubmodules = true; # needed for display_mirror css file
  };

  # override $HOME directory:
  #   error: [Errno 13] Permission denied: '/homeless-shelter'
  #
  # remove jellyfin_mpv_shim/win_utils.py:
  #   ModuleNotFoundError: No module named 'win32gui'
  preCheck = ''
    export HOME=$TMPDIR

    rm jellyfin_mpv_shim/win_utils.py
  '';

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

  meta = with stdenv.lib; {
    homepage = "https://github.com/iwalton3/jellyfin-mpv-shim";
    description = "Allows casting of videos to MPV via the jellyfin mobile and web app.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jojosch ];
  };
}
