{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  gtk2,
  libcddb,
  intltool,
  pkg-config,
  cdparanoia,
  mp3Support ? false,
  lame,
  oggSupport ? true,
  vorbis-tools,
  flacSupport ? true,
  flac,
  opusSupport ? false,
  opusTools,
  wavpackSupport ? false,
  wavpack,
  #, musepackSupport ? false, TODO: mpcenc
  monkeysAudioSupport ? false,
  monkeysAudio,
#, aacSupport ? false, TODO: neroAacEnc
}:

stdenv.mkDerivation rec {
  version = "3.0.1";
  pname = "asunder";
  src = fetchurl {
    url = "http://littlesvr.ca/asunder/releases/${pname}-${version}.tar.bz2";
    sha256 = "sha256-iGji4bl7ZofIAOf2EiYqMWu4V+3TmIN2jOYottJTN2s=";
  };

  nativeBuildInputs = [
    intltool
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    gtk2
    libcddb
  ];

  runtimeDeps =
    lib.optional mp3Support lame
    ++ lib.optional oggSupport vorbis-tools
    ++ lib.optional flacSupport flac
    ++ lib.optional opusSupport opusTools
    ++ lib.optional wavpackSupport wavpack
    ++ lib.optional monkeysAudioSupport monkeysAudio
    ++ [ cdparanoia ];

  postInstall = ''
    wrapProgram "$out/bin/asunder" \
      --prefix PATH : "${lib.makeBinPath runtimeDeps}"
  '';

  meta = with lib; {
    description = "A graphical Audio CD ripper and encoder for Linux";
    mainProgram = "asunder";
    homepage = "http://littlesvr.ca/asunder/index.php";
    license = licenses.gpl2;
    maintainers = with maintainers; [ mudri ];
    platforms = platforms.linux;

    longDescription = ''
      Asunder is a graphical Audio CD ripper and encoder for Linux. You can use
      it to save tracks from an Audio CD as any of WAV, MP3, OGG, FLAC, Opus,
      WavPack, Musepack, AAC, and Monkey's Audio files.
    '';
  };
}
