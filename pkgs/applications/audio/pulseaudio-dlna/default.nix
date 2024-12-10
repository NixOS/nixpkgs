{
  fetchFromGitHub,
  lib,
  python3Packages,
  mp3Support ? true,
  lame,
  opusSupport ? true,
  opusTools,
  faacSupport ? false,
  faac,
  flacSupport ? true,
  flac,
  soxSupport ? true,
  sox,
  vorbisSupport ? true,
  vorbis-tools,
  pulseaudio,
}:

python3Packages.buildPythonApplication {
  pname = "pulseaudio-dlna";
  version = "unstable-2021-11-09";

  src = fetchFromGitHub {
    owner = "Cygn";
    repo = "pulseaudio-dlna";
    rev = "637a2e7bba2277137c5f12fb58e63100dab7cbe6";
    sha256 = "sha256-Oda+zQQJE2D3fiNWTzxYvI8cZVHG5JAoV2Wf5Z6IU3M=";
  };

  patches = [
    ./0001-setup.py-remove-dbus-python-from-list.patch
  ];

  propagatedBuildInputs =
    with python3Packages;
    [
      dbus-python
      docopt
      requests
      setproctitle
      protobuf
      psutil
      chardet
      netifaces
      notify2
      pyroute2
      pygobject3
      pychromecast
      lxml
      setuptools
      zeroconf
    ]
    ++ lib.optional mp3Support lame
    ++ lib.optional opusSupport opusTools
    ++ lib.optional faacSupport faac
    ++ lib.optional flacSupport flac
    ++ lib.optional soxSupport sox
    ++ lib.optional vorbisSupport vorbis-tools;

  # pulseaudio-dlna shells out to pactl to configure sinks and sources.
  # As pactl might not be in $PATH, add --suffix it (so pactl configured by the
  # user get priority)
  makeWrapperArgs = [ "--suffix PATH : ${lib.makeBinPath [ pulseaudio ]}" ];

  # upstream has no tests
  checkPhase = ''
    $out/bin/pulseaudio-dlna --help > /dev/null
  '';

  meta = with lib; {
    description = "A lightweight streaming server which brings DLNA / UPNP and Chromecast support to PulseAudio and Linux";
    mainProgram = "pulseaudio-dlna";
    homepage = "https://github.com/Cygn/pulseaudio-dlna";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
  };
}
