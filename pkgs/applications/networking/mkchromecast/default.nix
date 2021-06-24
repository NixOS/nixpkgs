{ lib, stdenv
, fetchFromGitHub
, python3Packages
, sox
, flac
, lame
, wrapQtAppsHook
, ffmpeg
, vorbis-tools
, pulseaudio
, nodejs
, youtube-dl
, opusTools
, gst_all_1
}:
let packages = [
  vorbis-tools
  sox
  flac
  lame
  opusTools
  gst_all_1.gstreamer
  nodejs
  ffmpeg
  youtube-dl
] ++ lib.optionals stdenv.isLinux [ pulseaudio ];

in
python3Packages.buildPythonApplication rec {
  pname = "mkchromecast-unstable";
  version = "2020-10-17";

  src = fetchFromGitHub rec {
    owner = "muammar";
    repo = "mkchromecast";
    rev = "eb9da74d887acd70ed179e6e4c0cbed4ff83de04";
    sha256 = "1l565n3rmyghc4vzh80gazvdks1i97j1h94x33pkmxxlf9a9rncj";
  };

  propagatedBuildInputs = with python3Packages; [
    PyChromecast
    psutil
    mutagen
    flask
    netifaces
    requests
    pyqt5
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'platform.system() == "Darwin"' 'False' \
      --replace 'platform.system() == "Linux"' 'True'
  '';

  nativeBuildInputs = [ wrapQtAppsHook ];

  # Relies on an old version (0.7.7) of PyChromecast unavailable in Nixpkgs.
  # Is also I/O bound and impure, testing an actual device, so we disable.
  doCheck = false;

  dontWrapQtApps = true;

  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
    "--prefix PATH : ${lib.makeBinPath packages}"
  ];

  postInstall = ''
    substituteInPlace $out/lib/${python3Packages.python.libPrefix}/site-packages/mkchromecast/video.py \
      --replace '/usr/share/mkchromecast/nodejs/' '${placeholder "out"}/share/mkchromecast/nodejs/'
  '' + lib.optionalString stdenv.isDarwin ''
    install -Dm 755 -t $out/bin bin/audiodevice
    substituteInPlace $out/lib/${python3Packages.python.libPrefix}/site-packages/mkchromecast/audio_devices.py \
      --replace './bin/audiodevice' '${placeholder "out"}/bin/audiodevice'
  '';

  meta = with lib; {
    homepage = "https://mkchromecast.com/";
    description = "Cast macOS and Linux Audio/Video to your Google Cast and Sonos Devices";
    license = licenses.mit;
    maintainers = with maintainers; [ shou ];
  };
}
