{ stdenv, fetchurl, emacs, texinfo
, mpg321, vorbisTools, taglib, alsaUtils }:

# XXX: EMMS also supports Xine, MPlayer, Jack, etc.

stdenv.mkDerivation rec {
  name = "emms-3.0";

  src = fetchurl {
    # These guys don't use ftp.gnu.org...
    url = "http://www.gnu.org/software/emms/download/${name}.tar.gz";
    sha256 = "151mfx97x15lfpd1qc2sqbvhwhvg46axgh15qyqmdy42vh906xav";
  };

  buildInputs = [ emacs texinfo ];

  configurePhase = ''
    sed -i "Makefile" -e "s|PREFIX *=.*\$|PREFIX = $out|g ;
                          s|/usr/sbin/install-info|install-info|g ;
                          s|/usr/include/taglib|${taglib}/include/taglib|g ;
                          s|/usr/lib|${taglib}/lib|g ;
                          s|^all:\(.*\)\$|all:\1 emms-print-metadata|g"
    ensureDir "$out/share/man/man1"

    sed -i "emms-player-mpg321-remote.el" \
        -e 's|emms-player-mpg321-remote-command[[:blank:]]\+"mpg321"|emms-player-mpg321-remote-command "${mpg321}/bin/mpg321"|g'
    sed -i "emms-player-simple.el" \
        -e 's|"ogg123"|"${vorbisTools}/bin/ogg123"|g'
    sed -i "emms-info-ogginfo.el" \
        -e 's|emms-info-ogginfo-program-name[[:blank:]]\+"ogginfo"|emms-info-ogginfo-program-name "${vorbisTools}/bin/ogginfo"|g'
    sed -i "emms-info-libtag.el" \
        -e "s|\"emms-print-metadata\"|\"$out/bin/emms-print-metadata\"|g"
    sed -i "emms-volume-amixer.el" \
        -e 's|"amixer"|"${alsaUtils}/bin/amixer"|g'
  '';

  postInstall = ''
    ensureDir "$out/bin" && cp emms-print-metadata "$out/bin"
  '';
  
  meta = {
    description = "GNU EMMS, The Emacs Multimedia System";

    longDescription = ''
      EMMS is the Emacs Multimedia System.  It tries to be a clean and
      small application to play multimedia files from Emacs using
      external players.  Many of it's ideas are derived from
      MpthreePlayer, but it tries to be more general and cleaner.

      The fact that EMMS is based on external players makes it
      powerful, because it supports all formats that those players
      support, with no effort from your side.
    '';

    homepage = http://www.gnu.org/software/emms/;
    license = "GPLv3+";
  };
}
