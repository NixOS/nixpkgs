{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  sox,
  flac,
  lame,
  wrapQtAppsHook,
  ffmpeg,
  vorbis-tools,
  pulseaudio,
  nodejs,
  youtube-dl,
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
    youtube-dl
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ pulseaudio ];

in
python3Packages.buildPythonApplication {
  pname = "mkchromecast-unstable";
  version = "2022-10-31";

  src = fetchFromGitHub {
    owner = "muammar";
    repo = "mkchromecast";
    rev = "0de9fd78c4122dec4f184aeae2564790b45fe6dc";
    sha256 = "sha256-dxsIcBPrZaXlsfzOEXhYj2qoK5LRducJG2ggMrMMl9Y=";
  };

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

  postInstall =
    ''
      substituteInPlace $out/${python3Packages.python.sitePackages}/mkchromecast/video.py \
        --replace '/usr/share/mkchromecast/nodejs/' '${placeholder "out"}/share/mkchromecast/nodejs/'
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      install -Dm 755 -t $out/bin bin/audiodevice
      substituteInPlace $out/${python3Packages.python.sitePackages}/mkchromecast/audio_devices.py \
        --replace './bin/audiodevice' '${placeholder "out"}/bin/audiodevice'
    '';

  meta = with lib; {
    homepage = "https://mkchromecast.com/";
    description = "Cast macOS and Linux Audio/Video to your Google Cast and Sonos Devices";
    license = licenses.mit;
    maintainers = with maintainers; [ shou ];
    mainProgram = "mkchromecast";
  };
}
