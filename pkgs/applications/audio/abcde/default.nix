{ stdenv, fetchurl, libcdio, cddiscid, wget, bash, which, vorbis-tools, id3v2, eyeD3
, lame, flac, eject, mkcue
, perl, DigestSHA, MusicBrainz, MusicBrainzDiscID
, makeWrapper }:

let version = "2.7.2";
in
  stdenv.mkDerivation {
    name = "abcde-${version}";
    src = fetchurl {
      url = "http://abcde.einval.com/download/abcde-${version}.tar.gz";
      sha256 = "1pakpi41k8yd780mfp0snhia6mmwjwxk9lcrq6gynimch8b8hfda";
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

      substituteInPlace "abcde"					\
	--replace "/etc/abcde.conf" "$out/etc/abcde.conf"

    '';

    # no ELFs in this package, only scripts
    dontStrip = true;
    dontPatchELF = true;

    buildInputs = [ makeWrapper ];

    installFlags = [ "sysconfdir=$(out)/etc" ];

    postInstall = ''
    #   substituteInPlace "$out/bin/cddb-tool" \
    #      --replace '#!/bin/sh' '#!${bash}/bin/sh'
    #   substituteInPlace "$out/bin/abcde" \
    #      --replace '#!/bin/bash' '#!${bash}/bin/bash'

      # generic fixup script should be doing this, but it ignores this file for some reason
      substituteInPlace "$out/bin/abcde-musicbrainz-tool" \
         --replace '#!/usr/bin/perl' '#!${perl}/bin/perl'

      wrapProgram "$out/bin/abcde" --prefix PATH ":" \
        ${stdenv.lib.makeBinPath [ "$out" which libcdio cddiscid wget vorbis-tools id3v2 eyeD3 lame flac ]}

      wrapProgram "$out/bin/cddb-tool" --prefix PATH ":" \
        "${wget}/bin"

      wrapProgram "$out/bin/abcde-musicbrainz-tool" --prefix PATH ":" \
        "${wget}/bin"
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
