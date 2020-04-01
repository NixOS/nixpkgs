{ stdenv, fetchurl, fetchzip, libogg, libvorbis, libao, pkgconfig, curl
, speex, flac }:

let
  debPatch = fetchzip {
    url = "mirror://debian/pool/main/v/vorbis-tools/vorbis-tools_1.4.0-11.debian.tar.xz";
    sha256 = "0kvmd5nslyqplkdb7pnmqj47ir3y5lmaxd12wmrnqh679a8jhcyi";
  };
in
stdenv.mkDerivation {
  name = "vorbis-tools-1.4.0";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz;
    sha256 = "1g12bnh5ah08v529y72kfdz5lhvy75iaz7f9jskyby23m9dkk2d3";
  };

  postPatch = ''
    for patch in $(ls "${debPatch}"/patches/*.{diff,patch} | grep -v debian_subdir)
    do patch -p1 < "$patch"
    done
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libogg libvorbis libao curl speex flac ];

  meta = with stdenv.lib; {
    description = "Extra tools for Ogg-Vorbis audio codec";
    longDescription = ''
      A set of command-line tools to manipulate Ogg Vorbis audio
      files, notably the `ogg123' player and the `oggenc' encoder.
    '';
    homepage = https://xiph.org/vorbis/;
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}

