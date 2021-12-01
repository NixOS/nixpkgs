{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, python3Packages
, ffmpeg
, flac
, gobject-introspection
, gtk3
, libnotify
, libsamplerate
, libvorbis
, mpg123
, libopenmpt
, opusfile
, pango
, pulseaudio
, withDiscordRPC ? false
}:

stdenv.mkDerivation rec {
  pname = "tauon";
  version = "6.7.1";

  src = fetchFromGitHub {
    owner = "Taiko2k";
    repo = "TauonMusicBox";
    rev = "v${version}";
    sha256 = "1hm82yfq7q2akrrvff3vmwrd3bz34d2dk8jzhnizhnhar6xc6fzp";
  };

  postPatch = ''
    substituteInPlace tauon.py \
      --replace 'install_mode = False' 'install_mode = True' \
      --replace 'install_directory = os.path.dirname(__file__)' 'install_directory = "${placeholder "out"}/share/tauon"'

    substituteInPlace t_modules/t_main.py \
      --replace 'install_mode = False' 'install_mode = True' \
      --replace 'install_directory = sys.path[0]' 'install_directory = "${placeholder "out"}/share/tauon"' \
      --replace 'libopenmpt.so' '${lib.getLib libopenmpt}/lib/libopenmpt.so' \
      --replace 'lib/libphazor.so' '../../lib/libphazor.so'

    substituteInPlace t_modules/t_phazor.py \
      --replace 'lib/libphazor.so' '../../lib/libphazor.so'

    patchShebangs compile-phazor.sh
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
    libsamplerate
    libvorbis
    mpg123
    opusfile
    pango
    pulseaudio
  ];

  pythonPath = with python3Packages; [
    dbus-python
    isounidecode
    musicbrainzngs
    mutagen
    pillow
    pulsectl
    pycairo
    pylast
    pygobject3
    pylyrics
    pysdl2
    requests
    send2trash
  ] ++ lib.optional withDiscordRPC pypresence;

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ffmpeg]}"
    "--prefix PYTHONPATH : $out/share/tauon"
    "--set GI_TYPELIB_PATH $GI_TYPELIB_PATH"
  ];

  installPhase = ''
    install -Dm755 tauon.py $out/bin/tauon
    mkdir -p $out/share/tauon
    cp -r lib $out
    cp -r assets input.txt t_modules theme $out/share/tauon

    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "The Linux desktop music player from the future";
    homepage = "https://tauonmusicbox.rocks/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ SuperSandro2000 ];
    platforms = platforms.linux;
  };
}
