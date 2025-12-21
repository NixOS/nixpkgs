{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  python3Packages,
  sox,
  flac,
  lame,
  wrapQtAppsHook,
  ffmpeg,
  vorbis-tools,
  pulseaudio,
  nodejs,
  yt-dlp,
  opusTools,
  gst_all_1,
  enableSonos ? true,
  qtwayland,
}:
let
  packages = [
    vorbis-tools
    sox
    flac
    lame
    opusTools
    gst_all_1.gstreamer
    nodejs
    ffmpeg
    yt-dlp
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ pulseaudio ];

in
python3Packages.buildPythonApplication {
  pname = "mkchromecast-unstable";
  version = "2025-06-01";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "muammar";
    repo = "mkchromecast";
    rev = "6e583366ae23b56a33c1ad4ca164e04d64174538";
    hash = "sha256-CtmOkQAqUNn7+59mWEfAsgtWmGcXD3eE9j2t3sLnXms=";
  };

  patches = [
    # Update README to use yt-dlp instead of youtube-dl
    # https://github.com/muammar/mkchromecast/pull/480
    (fetchpatch2 {
      url = "https://github.com/muammar/mkchromecast/commit/0a0eec9bf4a6c000c828b83a864cebe18ce64c2b.patch";
      hash = "sha256-sLzL2/HDYfO0+N8v8aJX3dl7LBSE5yWa0zR89dZkg84=";
    })
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isLinux qtwayland;
  propagatedBuildInputs =
    with python3Packages;
    (
      [
        pychromecast
        psutil
        mutagen
        flask
        netifaces
        requests
        pyqt5
      ]
      ++ lib.optionals enableSonos [ soco ]
    );

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
    substituteInPlace $out/${python3Packages.python.sitePackages}/mkchromecast/video.py \
      --replace '/usr/share/mkchromecast/nodejs/' '${placeholder "out"}/share/mkchromecast/nodejs/'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install -Dm 755 -t $out/bin bin/audiodevice
    substituteInPlace $out/${python3Packages.python.sitePackages}/mkchromecast/audio_devices.py \
      --replace './bin/audiodevice' '${placeholder "out"}/bin/audiodevice'
  '';

  meta = {
    homepage = "https://mkchromecast.com/";
    description = "Cast macOS and Linux Audio/Video to your Google Cast and Sonos Devices";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shou ];
    mainProgram = "mkchromecast";
  };
}
