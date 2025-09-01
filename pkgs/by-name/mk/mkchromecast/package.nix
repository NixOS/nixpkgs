{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  libsForQt5,
  installShellFiles,
  sox,
  flac,
  lame,
  ffmpeg,
  vorbis-tools,
  pulseaudio,
  nodejs,
  yt-dlp,
  opusTools,
  gst_all_1,
  unstableGitUpdater,
  enableFfmpeg ? true,
  enablePyqt ? true,
  enableYtdl ? true,
  enableSonos ? true,
}:
python3Packages.buildPythonApplication {
  pname = "mkchromecast-unstable";
  version = "2022-10-31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "muammar";
    repo = "mkchromecast";
    rev = "0de9fd78c4122dec4f184aeae2564790b45fe6dc";
    hash = "sha256-dxsIcBPrZaXlsfzOEXhYj2qoK5LRducJG2ggMrMMl9Y=";
  };

  # Patch up the different paths to icons and stuff that are installed
  # with the derivation.
  postPatch = ''
    substituteInPlace mkchromecast.desktop \
      --replace-fail "/usr/bin/mkchromecast" "$out/bin/mkchromecast" \
      --replace-fail "/usr/share/pixmaps/mkchromecast.xpm" "$out/share/pixmaps/mkchromecast.xpm"

    substituteInPlace mkchromecast/audio_devices.py \
      --replace-fail "./bin/audiodevice" "$out/bin/audiodevice"

    substituteInPlace mkchromecast/video.py \
      --replace-fail "/usr/share/mkchromecast/nodejs/" "$out/share/mkchromecast/nodejs/"

    substituteInPlace mkchromecast/systray.py \
      --replace-fail '"images' "\"$out/share/mkchromecast/images"

    substituteInPlace mkchromecast/node.py \
      --replace-fail '"images' "\"$out/share/mkchromecast/images"
  '';

  build-system = [ python3Packages.setuptools ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libsForQt5.qtwayland ];

  dependencies = [
    python3Packages.pychromecast
    python3Packages.psutil
    python3Packages.mutagen
    python3Packages.flask
    python3Packages.netifaces
    python3Packages.requests
  ]
  ++ lib.optionals enablePyqt [ python3Packages.pyqt5 ]
  ++ lib.optionals enableSonos [ python3Packages.soco ];

  nativeBuildInputs = [
    installShellFiles
    libsForQt5.wrapQtAppsHook
  ];

  # Relies on an old version (0.7.7) of PyChromecast unavailable in Nixpkgs.
  # Is also I/O bound and impure, testing an actual device, so we disable.
  doCheck = false;

  makeWrapperArgs =
    let
      path = [
        vorbis-tools
        sox
        flac
        lame
        opusTools
        gst_all_1.gstreamer
        nodejs
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [ pulseaudio ]
      ++ lib.optionals enableFfmpeg [ ffmpeg ]
      ++ lib.optionals enableYtdl [ yt-dlp ];
    in
    [
      "--prefix PATH : ${lib.makeBinPath path}"
    ];

  postInstall = ''
    installManPage mkchromecast.1

    install -Dm644 mkchromecast.desktop -t "$out/share/applications/"
    install -Dm644 "images/mkchromecast.xpm" -t "$out/share/pixmaps/"

  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install -Dm 755 -t "$out/bin" "bin/audiodevice"
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://mkchromecast.com/";
    description = "Cast macOS and Linux Audio/Video to your Google Cast and Sonos Devices";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      shou
      RossSmyth
    ];
    mainProgram = "mkchromecast";
  };
}
