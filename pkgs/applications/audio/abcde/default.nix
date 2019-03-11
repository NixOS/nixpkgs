{ stdenv, fetchurl, libcdio-paranoia, cddiscid, wget, which, vorbis-tools, id3v2, eyeD3
, lame, flac, glyr
, perlPackages
, makeWrapper }:

let version = "2.9.3";
in
  stdenv.mkDerivation {
    name = "abcde-${version}";
    src = fetchurl {
      url = "https://abcde.einval.com/download/abcde-${version}.tar.gz";
      sha256 = "091ip2iwb6b67bhjsj05l0sxyq2whqjycbzqpkfbpm4dlyxx0v04";
    };

    # FIXME: This package does not support `distmp3', `eject', etc.

    configurePhase = ''
      sed -i "s|^[[:blank:]]*prefix *=.*$|prefix = $out|g ;
              s|^[[:blank:]]*etcdir *=.*$|etcdir = $out/etc|g ;
              s|^[[:blank:]]*INSTALL *=.*$|INSTALL = install -c|g" \
        "Makefile";

      echo 'CDPARANOIA=${libcdio-paranoia}/bin/cd-paranoia' >>abcde.conf
      echo CDROMREADERSYNTAX=cdparanoia >>abcde.conf

      substituteInPlace "abcde" \
        --replace "/etc/abcde.conf" "$out/etc/abcde.conf"
    '';

    nativeBuildInputs = [ makeWrapper ];

    buildInputs = with perlPackages; [ perl MusicBrainz MusicBrainzDiscID ];

    installFlags = [ "sysconfdir=$(out)/etc" ];

    postFixup = ''
      for cmd in abcde cddb-tool abcde-musicbrainz-tool; do
        wrapProgram "$out/bin/$cmd" \
          --prefix PERL5LIB : "$PERL5LIB" \
          --prefix PATH ":" ${stdenv.lib.makeBinPath [
            "$out" which libcdio-paranoia cddiscid wget
            vorbis-tools id3v2 eyeD3 lame flac glyr
          ]}
      done
    '';

    meta = with stdenv.lib; {
      homepage = http://abcde.einval.com/wiki/;
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ gebner ];
      description = "Command-line audio CD ripper";
      longDescription = ''
        abcde is a front-end command-line utility (actually, a shell
        script) that grabs tracks off a CD, encodes them to
        Ogg/Vorbis, MP3, FLAC, Ogg/Speex and/or MPP/MP+ (Musepack)
        format, and tags them, all in one go.
      '';
      platforms = platforms.linux;
    };
  }
