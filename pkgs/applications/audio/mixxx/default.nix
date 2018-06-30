{ stdenv, fetchurl, chromaprint, fetchpatch, fftw, flac, faad2, mp4v2
, libid3tag, libmad, libopus, libshout, libsndfile, libusb1, libvorbis
, pkgconfig, portaudio, portmidi, protobuf, qt4, rubberband, scons, sqlite
, taglib, vampSDK
}:

stdenv.mkDerivation rec {
  name = "mixxx-${version}";
  version = "2.0.0";

  src = fetchurl {
    url = "https://downloads.mixxx.org/${name}/${name}-src.tar.gz";
    sha256 = "0vb71w1yq0xwwsclrn2jj9bk8w4n14rfv5c0aw46c11mp8xz7f71";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.net/data/main/m/mixxx/2.0.0~dfsg-7.1/debian/patches/0007-fix_gcc6_issue.patch";
      sha256 = "0kpyv10wcjcvbijk6vpq54gx9sqzrq4kq2qilc1czmisp9qdy5sd";
    })
    (fetchpatch {
      url = "https://622776.bugs.gentoo.org/attachment.cgi?id=487284";
      name = "sqlite.patch";
      sha256 = "1qqbd8nrxrjcc1dwvyqfq1k2yz3l071sfcgd2dmpk6j8d4j5kx31";
    })
 ];

  buildInputs = [
    chromaprint fftw flac faad2 mp4v2 libid3tag libmad libopus libshout libsndfile
    libusb1 libvorbis pkgconfig portaudio portmidi protobuf qt4
    rubberband scons sqlite taglib vampSDK
  ];

  sconsFlags = [
    "build=release"
    "qtdir=${qt4}"
    "faad=1"
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p "$out"
    scons \
      -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES \
      $sconsFlags "prefix=$out"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    scons $sconsFlags "prefix=$out" install
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = https://mixxx.org;
    description = "Digital DJ mixing software";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.aszlig maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
