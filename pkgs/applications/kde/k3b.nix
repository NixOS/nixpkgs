{ mkDerivation, lib
, extra-cmake-modules, kdoctools, makeWrapper, shared-mime-info
, qtwebkit
, libkcddb, karchive, kcmutils, kfilemetadata, knewstuff, knotifyconfig, solid, kxmlgui
, flac, lame, libmad, libmpcdec, libvorbis
, libsamplerate, libsndfile, taglib
, cdparanoia, cdrdao, cdrtools, dvdplusrwtools, libburn, libdvdcss, libdvdread, vcdimager
, ffmpeg, libmusicbrainz3, normalize, sox, transcode, kinit
}:

mkDerivation {
  name = "k3b";
  meta = with lib; {
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ sander phreedom ];
    platforms = platforms.linux;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeWrapper ];
  propagatedBuildInputs = [
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
    ffmpeg libmusicbrainz3 shared-mime-info
  ];
  propagatedUserEnvPkgs = [ (lib.getBin kinit) ];
  postFixup =
    let k3bPath = lib.makeBinPath [
          cdrdao cdrtools dvdplusrwtools libburn normalize sox transcode
          vcdimager
        ];
    in ''
      wrapProgram "$out/bin/k3b" --prefix PATH : "${k3bPath}"
    '';
}
