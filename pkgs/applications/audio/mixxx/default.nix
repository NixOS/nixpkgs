{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig, scons
, qtbase, qttools, qtscript, qtsvg, qtxmlpatterns
, chromaprint, fftw, flac, libid3tag, libmad
, libopus, libshout, libsndfile, libusb1, libvorbis, mesa
, portaudio, portmidi, protobuf, rubberband, sqlite
, taglib, vampSDK
}:

stdenv.mkDerivation rec {
  name = "mixxx-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "mixxxdj";
    repo = "mixxx";
    rev = "release-${version}";
    sha256 = "0pipmkv5fig2pajlh5nnmxyfil7mv5l86cw6rh8jbkcr9hman9bp";
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
    chromaprint fftw flac libid3tag libmad libopus libshout libsndfile
    libusb1 libvorbis mesa portaudio portmidi protobuf
    rubberband sqlite taglib vampSDK
    qtbase qtscript qtsvg qtxmlpatterns
  ];

  nativeBuildInputs = [
    pkgconfig qttools scons
  ];

  enableParallelBuilding = true;

  sconsFlags = [
    "build=release"
    "qt5=1"
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
    description = "Digital DJ mixing software";
    homepage = https://mixxx.org;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ aszlig goibhniu ];
    platforms = platforms.linux;
  };
}
