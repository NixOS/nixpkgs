{ mkDerivation, lib
, extra-cmake-modules, kdoctools, makeWrapper, shared-mime-info
, qtwebkit
, libkcddb, karchive, kcmutils, kfilemetadata, knewstuff, knotifyconfig, solid, kxmlgui
, flac, lame, libmad, libmpcdec, libvorbis
, libsamplerate, libsndfile, taglib
, cdparanoia, cdrdao, cdrtools, dvdplusrwtools, libburn, libdvdcss, libdvdread, vcdimager
, ffmpeg_3, libmusicbrainz3, normalize, sox, transcode, kinit
}:

mkDerivation {
  name = "k3b";
  meta = with lib; {
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ sander phreedom ];
    platforms = platforms.linux;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeWrapper ];
  buildInputs = [
    # qt
    qtwebkit
    # kde
    libkcddb karchive kcmutils kfilemetadata knewstuff knotifyconfig solid kxmlgui
    # formats
    flac lame libmad libmpcdec libvorbis
    # sound utilities
    libsamplerate libsndfile taglib
    # cd/dvd
    cdparanoia libdvdcss libdvdread
    # others
    ffmpeg_3 libmusicbrainz3 shared-mime-info
  ];
  propagatedUserEnvPkgs = [ (lib.getBin kinit) ];
  postFixup =
    let
      binPath = lib.makeBinPath [
        cdrdao cdrtools dvdplusrwtools libburn normalize sox transcode
        vcdimager flac
      ];
      libraryPath = lib.makeLibraryPath [
        cdparanoia
      ];
    in ''
      wrapProgram "$out/bin/k3b"     \
        --prefix PATH : "${binPath}" \
        --prefix LD_LIBRARY_PATH : ${libraryPath}
    '';
}
