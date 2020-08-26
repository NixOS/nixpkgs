{ stdenv, fetchurl, makeWrapper, gtk2, libcddb, intltool, pkgconfig, cdparanoia
, mp3Support ? false, lame
, oggSupport ? true, vorbis-tools
, flacSupport ? true, flac
, opusSupport ? false, opusTools
, wavpackSupport ? false, wavpack
#, musepackSupport ? false, TODO: mpcenc
, monkeysAudioSupport ? false, monkeysAudio
#, aacSupport ? false, TODO: neroAacEnc
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "2.9.6";
  pname = "asunder";
  src = fetchurl {
    url = "http://littlesvr.ca/asunder/releases/${pname}-${version}.tar.bz2";
    sha256 = "1ycnd82lh7qy1pcbngd4b41s16j9hnm2kyfrncg4cwr3bfk7yg7a";
  };

  nativeBuildInputs = [ intltool makeWrapper pkgconfig ];
  buildInputs = [ gtk2 libcddb ];

  runtimeDeps =
    optional mp3Support lame ++
    optional oggSupport vorbis-tools ++
    optional flacSupport flac ++
    optional opusSupport opusTools ++
    optional wavpackSupport wavpack ++
    optional monkeysAudioSupport monkeysAudio ++
    [ cdparanoia ];

  postInstall = ''
    wrapProgram "$out/bin/asunder" \
      --prefix PATH : "${makeBinPath runtimeDeps}"
  '';

  meta = {
    description = "A graphical Audio CD ripper and encoder for Linux";
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
