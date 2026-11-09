{
  lib,
  python3Packages,
  fetchFromGitHub,
  qt6,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  ffmpeg,
  deno,
  yt-dlp,
  curl,
  cacert,
  hicolor-icon-theme,
  papirus-icon-theme,
  adwaita-icon-theme,
  gtk3,
  gsettings-desktop-schemas,
  gdk-pixbuf,
  librsvg,
  gst_all_1,
  libpulseaudio,
  alsa-lib,
}:

let
  pythonEnv = python3Packages.python.withPackages (
    ps: with ps; [
      pyside6
      pyyaml
      numpy
      dbus-next
      requests
    ]
  );
in
python3Packages.buildPythonApplication rec {
  pname = "msmp-foxwave";
  version = "6.2.2-alpha";

  src = fetchFromGitHub {
    owner = "maxsspeaker";
    repo = "MSMP-6";
    rev = "e08257802be2df0f9f04";
    hash = "sha256-/ZPvM4JfHKyGowin/jn7jDLlyRgA9B2l3uLNAussKAw=";
  };

  postPatch = ''
    substituteInPlace modules/pluginLoader.py \
      --replace-fail "self.plugins_dir = " "self.plugins_dir = Path(os.path.expanduser('~/.config/MSMP-Stream/6.0/plugins')) # "
  '';

  dependencies = with python3Packages; [
    pyside6
    pyyaml
    numpy
    dbus-next
    requests
  ];

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtsvg
    qt6.qtwayland
    qt6.qtimageformats
    gdk-pixbuf
    librsvg
    gtk3
    gsettings-desktop-schemas
    hicolor-icon-theme
    papirus-icon-theme
    adwaita-icon-theme
    cacert
    curl
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    libpulseaudio
    alsa-lib
    ffmpeg
    deno
    yt-dlp
  ];

  format = "other";
  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/${pname}
    cp -r . $out/opt/${pname}

    makeWrapper ${pythonEnv.interpreter} $out/bin/${pname} \
      --add-flags "$out/opt/${pname}/main.py" \
      --chdir "$out/opt/${pname}" \
      --set QT_AUDIO_BACKEND "PulseAudio" \
      --set QT_QPA_PLATFORMTHEME "gtk3" \
      --set QT_QPA_SYSTEM_ICON_THEME "Papirus" \
      --set SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt" \
      --set NIX_SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt" \
      --prefix PYTHONPATH : "$out/opt/${pname}" \
      --prefix PATH : "${
        lib.makeBinPath [
          ffmpeg
          deno
          yt-dlp
          curl
        ]
      }" \
      --prefix XDG_DATA_DIRS : "${hicolor-icon-theme}/share:${adwaita-icon-theme}/share:${papirus-icon-theme}/share:${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gdk-pixbuf}/share"

    install -Dm644 $out/opt/${pname}/resources/MSMPicon.png \
      $out/share/icons/hicolor/256x256/apps/${pname}.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = "MSMP FoxWave";
      comment = "Streaming audio player for PC";
      categories = [
        "AudioVideo"
        "Audio"
        "Player"
      ];
    })
  ];

  meta = with lib; {
    description = "MSMP FoxWave - streaming audio player for PC";
    homepage = "https://github.com/maxsspeaker/MSMP-6";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ NikitaWolf17 ];
    mainProgram = pname;
    platforms = platforms.linux;
  };
}
