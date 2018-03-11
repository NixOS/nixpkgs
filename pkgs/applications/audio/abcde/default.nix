{ stdenv, fetchurl, libcdio-paranoia, cddiscid, wget, bash, which, vorbis-tools, id3v2, eyeD3
, lame, flac, eject, mkcue, glyr
, perl, DigestSHA, MusicBrainz, MusicBrainzDiscID
, makeWrapper }:

let version = "2.8.1";
in
  stdenv.mkDerivation {
    name = "abcde-${version}";
    src = fetchurl {
      url = "http://abcde.einval.com/download/abcde-${version}.tar.gz";
      sha256 = "0f9bjs0phk23vry7gvh0cll9vl6kmc1y4fwwh762scfdvpbp3774";
    };

    # FIXME: This package does not support `distmp3', `eject', etc.

    patches = [ ./abcde.patch ];

    configurePhase = ''
      sed -i "s|^[[:blank:]]*prefix *=.*$|prefix = $out|g ;
              s|^[[:blank:]]*etcdir *=.*$|etcdir = $out/etc|g ;
              s|^[[:blank:]]*INSTALL *=.*$|INSTALL = install -c|g" \
        "Makefile";

      # We use `cd-paranoia' from GNU libcdio, which contains a hyphen
      # in its name, unlike Xiph's cdparanoia.
      sed -i "s|^[[:blank:]]*CDPARANOIA=.*$|CDPARANOIA=cd-paranoia|g ;
              s|^[[:blank:]]*DEFAULT_CDROMREADERS=.*$|DEFAULT_CDROMREADERS=\"cd-paranoia cdda2wav\"|g" \
        "abcde"

      substituteInPlace "abcde" \
        --replace "/etc/abcde.conf" "$out/etc/abcde.conf"

    '';

    buildInputs = [ makeWrapper ];

    propagatedBuildInputs = [ perl DigestSHA MusicBrainz MusicBrainzDiscID ];

    installFlags = [ "sysconfdir=$(out)/etc" ];

    postFixup = ''
      for cmd in abcde cddb-tool abcde-musicbrainz-tool; do
        wrapProgram "$out/bin/$cmd" --prefix PATH ":" \
          ${stdenv.lib.makeBinPath [ "$out" which libcdio-paranoia cddiscid wget vorbis-tools id3v2 eyeD3 lame flac glyr ]}
      done
    '';

    meta = {
      homepage = http://abcde.einval.com/wiki/;
      license = stdenv.lib.licenses.gpl2Plus;
      description = "Command-line audio CD ripper";

      longDescription = ''
        abcde is a front-end command-line utility (actually, a shell
        script) that grabs tracks off a CD, encodes them to
        Ogg/Vorbis, MP3, FLAC, Ogg/Speex and/or MPP/MP+ (Musepack)
        format, and tags them, all in one go.
      '';
      platforms = stdenv.lib.platforms.linux;
    };
  }
