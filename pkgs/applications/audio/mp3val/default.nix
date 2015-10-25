{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.1.8";
  name = "mp3val-${version}";
  src = fetchurl {
    url = "http://downloads.sourceforge.net/mp3val/${name}-src.tar.gz";
    sha256 = "17y3646ghr38r620vkrxin3dksxqig5yb3nn4cfv6arm7kz6x8cm";
  };

  makefile = "Makefile.linux";

  installPhase = ''
    mkdir -p $out/bin/
    cp mp3val $out/bin/
  '';

  meta = {
    description = "A tool for validating and repairing MPEG audio streams";
    longDescription = ''
      MP3val is a small, high-speed, free software tool for checking MPEG audio
      files' integrity. It can be useful for finding corrupted files (e.g.
      incompletely downloaded, truncated, containing garbage). MP3val is
      also able to fix most of the problems. Being a multiplatform application,
      MP3val can be runned both under Windows and under Linux (or BSD). The most
      common MPEG audio file type is MPEG 1 Layer III (mp3), but MP3val supports
      also other MPEG versions and layers. The tool is also aware of the most
      common types of tags (ID3v1, ID3v2, APEv2).
    '';
    homepage = http://mp3val.sourceforge.net/index.shtml;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
