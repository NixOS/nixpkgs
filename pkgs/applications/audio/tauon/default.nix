{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, python3Packages
, ffmpeg
, flac
, libjxl
, librsvg
, gobject-introspection
, gtk3
, kissfft
, libnotify
, libsamplerate
, libvorbis
, miniaudio
, mpg123
, libopenmpt
, opusfile
, wavpack
, pango
, pulseaudio
, withDiscordRPC ? false
}:

stdenv.mkDerivation rec {
  pname = "tauon";
  version = "7.4.7";

  src = fetchFromGitHub {
    owner = "Taiko2k";
    repo = "TauonMusicBox";
    rev = "v${version}";
    sha256 = "sha256-WUHMXsbnNaDlV/5bCOPMadJKWoF5i2UlFf9fcX6GCZ0=";
  };

  postUnpack = ''
    rmdir source/src/phazor/kissfft
    ln -s ${kissfft.src} source/src/phazor/kissfft

    rmdir source/src/phazor/miniaudio
    ln -s ${miniaudio.src} source/src/phazor/miniaudio
  '';

  postPatch = ''
    substituteInPlace tauon.py \
      --replace 'install_mode = False' 'install_mode = True' \
      --replace 'install_directory = os.path.dirname(os.path.abspath(__file__))' 'install_directory = "${placeholder "out"}/share/tauon"'

    substituteInPlace t_modules/t_main.py \
      --replace 'install_mode = False' 'install_mode = True' \
      --replace 'libopenmpt.so' '${lib.getLib libopenmpt}/lib/libopenmpt.so' \
      --replace 'lib/libphazor.so' '../../lib/libphazor.so'

    substituteInPlace t_modules/t_phazor.py \
      --replace 'lib/libphazor.so' '../../lib/libphazor.so'

    patchShebangs compile-phazor.sh

    substituteInPlace extra/tauonmb.desktop --replace 'Exec=/opt/tauon-music-box/tauonmb.sh' 'Exec=${placeholder "out"}/bin/tauon'
  '';

  postBuild = ''
    ./compile-phazor.sh
  '';

  nativeBuildInputs = [
    pkg-config
    python3Packages.wrapPython
  ];

  buildInputs = [
    flac
    gobject-introspection
    gtk3
    libnotify
    libopenmpt
    librsvg
    libsamplerate
    libvorbis
    mpg123
    opusfile
    pango
    wavpack
  ];

  pythonPath = with python3Packages; [
    beautifulsoup4
    gst-python
    dbus-python
    isounidecode
    libjxl
    musicbrainzngs
    mutagen
    natsort
    pillow
    plexapi
    pulsectl
    pycairo
    PyChromecast
    pylast
    pygobject3
    pylyrics
    pysdl2
    requests
    send2trash
    setproctitle
  ] ++ lib.optional withDiscordRPC pypresence;

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ffmpeg]}"
    "--prefix LD_LIBRARY_PATH : ${pulseaudio}/lib"
    "--prefix PYTHONPATH : $out/share/tauon"
    "--set GI_TYPELIB_PATH $GI_TYPELIB_PATH"
  ];

  installPhase = ''
    install -Dm755 tauon.py $out/bin/tauon
    mkdir -p $out/share/tauon
    cp -r lib $out
    cp -r assets input.txt t_modules theme templates $out/share/tauon

    wrapPythonPrograms

    mkdir -p $out/share/applications
    install -Dm755 extra/tauonmb.desktop $out/share/applications/tauonmb.desktop
    mkdir -p $out/share/icons/hicolor/scalable/apps
    install -Dm644 extra/tauonmb{,-symbolic}.svg $out/share/icons/hicolor/scalable/apps
  '';

  meta = with lib; {
    description = "The Linux desktop music player from the future";
    homepage = "https://tauonmusicbox.rocks/";
    changelog = "https://github.com/Taiko2k/TauonMusicBox/releases/tag/v${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jansol ];
    platforms = platforms.linux;
  };
}
