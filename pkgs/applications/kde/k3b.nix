{ kdeApp, lib, kdeWrapper, extra-cmake-modules
, qtwebkit
, libkcddb, kcmutils, kdoctools, kfilemetadata, knewstuff, knotifyconfig, solid, kxmlgui
, flac, lame, libmad, libmpcdec, libvorbis
, libsamplerate, libsndfile, taglib
, cdparanoia, cdrdao, cdrtools, dvdplusrwtools, libburn, libdvdcss, libdvdread, vcdimager
, ffmpeg, libmusicbrainz2, normalize, sox, transcode
}:

let
  unwrapped =
    kdeApp {
      name = "k3b";
      meta = with lib; {
        license = with licenses; [ gpl2Plus ];
        maintainers = with maintainers; [ sander phreedom ];
        platforms = platforms.linux;
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        # qt
        qtwebkit
        # kde
        libkcddb kcmutils kfilemetadata knewstuff knotifyconfig solid kxmlgui
        # formats
        flac lame libmad libmpcdec libvorbis
        # sound utilities
        libsamplerate libsndfile taglib
        # cd/dvd
        cdparanoia libdvdcss libdvdread
        # others
        ffmpeg libmusicbrainz2
      ];
      enableParallelBuilding = true;
    };

in kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/k3b" ];
  paths = [ cdrdao cdrtools dvdplusrwtools libburn normalize sox transcode vcdimager ];
}
