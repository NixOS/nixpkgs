{ stdenv, buildPythonApplication, fetchPypi, callPackage
, mpv, python-mpv-jsonipc, jellyfin-apiclient-python
, pillow, tkinter, pystray, jinja2, pywebview, pydantic }:

buildPythonApplication rec {
  pname = "jellyfin-mpv-shim";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5fb50be6e51e81db4773c3c6b9c2dcf0e4295a7c347f157cf33e24e45826204d";
  };

  patches = [
    patches/disable-desktop-client.patch
    patches/disable-update-check.patch
  ];

  propagatedBuildInputs = [
    jellyfin-apiclient-python
    mpv
    pillow
    python-mpv-jsonipc
    pydantic

    # gui dependencies
    pystray
    tkinter

    # display_mirror dependencies
    jinja2
    pywebview
  ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "jellyfin_mpv_shim" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/iwalton3/jellyfin-mpv-shim";
    description = "Allows casting of videos to MPV via the jellyfin mobile and web app";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jojosch ];
  };
}
