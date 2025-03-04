{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  makeWrapper,
  shared-mime-info,
  libkcddb,
  karchive,
  kcmutils,
  kfilemetadata,
  knewstuff,
  knotifyconfig,
  solid,
  kxmlgui,
  flac,
  lame,
  libmad,
  libmpcdec,
  libvorbis,
  libsamplerate,
  libsndfile,
  taglib,
  cdparanoia,
  cdrdao,
  cdrtools,
  dvdplusrwtools,
  libburn,
  libdvdcss,
  libdvdread,
  vcdimager,
  ffmpeg,
  libmusicbrainz3,
  normalize,
  sox,
  transcode,
  kinit,
  fetchpatch,
}:

mkDerivation {
  pname = "k3b";
  meta = with lib; {
    homepage = "https://apps.kde.org/k3b/";
    description = "Disk burning application";
    mainProgram = "k3b";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ sander ];
    platforms = platforms.linux;
  };
  patches = [
    # compile fixes from upstream, remove when they stop applying
    (fetchpatch {
      url = "https://github.com/KDE/k3b/commit/712ef4adc992fd848dfd769f346f87216029c285.diff";
      sha256 = "sha256-wtLbd6WrytMrF4elPmR7auC7j+id0Ioom6TDQORkI/A=";
    })
    (fetchpatch {
      url = "https://github.com/KDE/k3b/commit/071535a79c3d2b074163cbb0881117a995ed17cd.diff";
      sha256 = "sha256-L7ZkIu8c/ns2KrvFD4icvUX5ibHcarPZxp3NRsvMowY=";
    })
  ];
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeWrapper
  ];
  buildInputs = [
    # kde
    libkcddb
    karchive
    kcmutils
    kfilemetadata
    knewstuff
    knotifyconfig
    solid
    kxmlgui
    # formats
    flac
    lame
    libmad
    libmpcdec
    libvorbis
    # sound utilities
    libsamplerate
    libsndfile
    taglib
    # cd/dvd
    cdparanoia
    libdvdcss
    libdvdread
    # others
    ffmpeg
    libmusicbrainz3
    shared-mime-info
  ];
  propagatedUserEnvPkgs = [ (lib.getBin kinit) ];
  postFixup =
    let
      binPath = lib.makeBinPath [
        cdrdao
        cdrtools
        dvdplusrwtools
        libburn
        normalize
        sox
        transcode
        vcdimager
        flac
      ];
      libraryPath = lib.makeLibraryPath [
        cdparanoia
      ];
    in
    ''
      wrapProgram "$out/bin/k3b"     \
        --prefix PATH : "${binPath}" \
        --prefix LD_LIBRARY_PATH : ${libraryPath}
    '';
}
