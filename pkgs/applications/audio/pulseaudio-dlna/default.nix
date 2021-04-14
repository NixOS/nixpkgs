{ lib
, buildPythonApplication
, fetchFromGitHub
, chardet
, dbus-python
, docopt
, lxml
, netifaces
, notify2
, protobuf
, psutil
, PyChromecast
, pygobject2
, pyroute2
, requests
, setproctitle
, setuptools
, zeroconf
, mp3Support ? true, lame
, opusSupport ? true, opusTools
, faacSupport ? false, faac
, flacSupport ? true, flac
, soxSupport ? true, sox
, vorbisSupport ? true, vorbis-tools
}:

buildPythonApplication rec {
  pname = "pulseaudio-dlna";
  version = "unstable-2019-02-09";

  src = fetchFromGitHub {
    owner = "masmu";
    repo = "pulseaudio-dlna";
    rev = "b0db8137224f5a293329a60187365168304c3768";  # HEAD of "python3" branch
    sha256 = "109dhww3vq87apwrbl82ylcvl595vm1aw04y217fidd854xbh07h";
  };

  propagatedBuildInputs = [
    chardet
    dbus-python
    docopt
    lxml
    netifaces
    notify2
    protobuf
    psutil
    PyChromecast
    pygobject2
    pyroute2
    requests
    setproctitle
    setuptools
    zeroconf
  ]
    ++ lib.optional mp3Support lame
    ++ lib.optional opusSupport opusTools
    ++ lib.optional faacSupport faac
    ++ lib.optional flacSupport flac
    ++ lib.optional soxSupport sox
    ++ lib.optional vorbisSupport vorbis-tools;

  # upstream has no tests
  checkPhase = ''
    $out/bin/pulseaudio-dlna --help > /dev/null
  '';

  meta = with lib; {
    description = "A lightweight streaming server which brings DLNA / UPNP and Chromecast support to PulseAudio and Linux";
    homepage = "https://github.com/masmu/pulseaudio-dlna";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
  };
}
