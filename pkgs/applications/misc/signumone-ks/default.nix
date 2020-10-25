{ stdenv, fetchurl, dpkg, autoPatchelfHook, makeWrapper,
  atk, ffmpeg, ffmpeg_2, ffmpeg_3, gdk-pixbuf, glibc, gtk2-x11, gtk3, libav_0_8,
  libXtst, pango }:

stdenv.mkDerivation rec {
  pname = "signumone-ks";
  version = "3.1.2";

  src = fetchurl {
    url = "https://cdn-dist.signum.one/${version}/${pname}-${version}.deb";
    sha256 = "4efd80e61619ccf26df1292194fcec68eb14d77dfcf0a1a673da4cf5bf41f4b7";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    atk glibc gdk-pixbuf stdenv.cc.cc ffmpeg ffmpeg_2 ffmpeg_3
    libav_0_8 gtk2-x11 gtk3 pango libXtst
  ];

  libPath = stdenv.lib.makeLibraryPath buildInputs;

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase = ''
    DESKTOP_PATH=$out/share/applications/signumone-ks.desktop
    LIB_DIR=$out/lib/signumone-ks

    mkdir -p $out/{bin,share/applications,lib/signumone-ks}
    mv opt/SignumOne-KS/SignumOne-KS.desktop $DESKTOP_PATH
    mv opt $out

    # Based on https://github.com/NixOS/nixpkgs/pull/50220/files
    # Wasn't able to find them
    ln -s ${ffmpeg_2.out}/lib/libavcodec.so.56 $LIB_DIR/libavcodec-ffmpeg.so.56
    ln -s ${ffmpeg_2.out}/lib/libavcodec.so.56 $LIB_DIR/libavcodec.so.55
    ln -s ${ffmpeg_2.out}/lib/libavcodec.so.56 $LIB_DIR/libavcodec.so.54
    ln -s ${ffmpeg_2.out}/lib/libavformat.so.56 $LIB_DIR/libavformat-ffmpeg.so.56
    ln -s ${ffmpeg_2.out}/lib/libavformat.so.56 $LIB_DIR/libavformat.so.55
    ln -s ${ffmpeg_2.out}/lib/libavformat.so.56 $LIB_DIR/libavformat.so.54

    sed -e "s|\(Exec=\)/opt/SignumOne-KS|\1$out/bin|g" -i $DESKTOP_PATH
    sed -e "s|\(Icon=\)|\1$out|g" -i $DESKTOP_PATH

    makeWrapper $out/opt/SignumOne-KS/SignumOne-KS \
      $out/bin/SignumOne-KS \
      --prefix LD_LIBRARY_PATH : ${libPath}
  '';

  meta = with stdenv.lib; {
    description = "Software intended for usage with Costa Rica's \"Firma Digital\" requirements";
    homepage = "https://signum.one/download.html";
    license = licenses.unfree;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
