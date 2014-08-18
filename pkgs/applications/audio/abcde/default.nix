{ stdenv, fetchurl, libcdio, cddiscid, wget, bash, vorbisTools, id3v2, lame, flac, eject, mkcue
, perl, DigestSHA, MusicBrainz, MusicBrainzDiscID
, makeWrapper }:

let version = "2.5.4";
in
  stdenv.mkDerivation {
    name = "abcde-${version}";
    src = fetchurl {
      url = "mirror://debian/pool/main/a/abcde/abcde_${version}.orig.tar.gz";
      sha256 = "14g5lsgh53hza9848351kwpygc0yqpvvzp3s923aja77f2wpkdl5";
    };

    # FIXME: This package does not support MP3 encoding (only Ogg),
    # nor `distmp3', `eject', etc.

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

    postInstall = ''
    #   substituteInPlace "$out/bin/cddb-tool" \
    #      --replace '#!/bin/sh' '#!${bash}/bin/sh'
    #   substituteInPlace "$out/bin/abcde" \
    #      --replace '#!/bin/bash' '#!${bash}/bin/bash'

      # generic fixup script should be doing this, but it ignores this file for some reason
      substituteInPlace "$out/bin/abcde-musicbrainz-tool" \
         --replace '#!/usr/bin/perl' '#!${perl}/bin/perl'

      wrapProgram "$out/bin/abcde" --prefix PATH ":" \
        "$out/bin:${libcdio}/bin:${cddiscid}/bin:${wget}/bin:${vorbisTools}/bin:${id3v2}/bin:${lame}/bin"

      wrapProgram "$out/bin/cddb-tool" --prefix PATH ":" \
        "${wget}/bin"

      wrapProgram "$out/bin/abcde-musicbrainz-tool" --prefix PATH ":" \
        "${wget}/bin"
    '';

    meta = {
      homepage = "http://lly.org/~rcw/abcde/page/";
      license = "GPLv2+";
      description = "Command-line audio CD ripper";

      longDescription = ''
        abcde is a front-end command-line utility (actually, a shell
        script) that grabs tracks off a CD, encodes them to
        Ogg/Vorbis, MP3, FLAC, Ogg/Speex and/or MPP/MP+ (Musepack)
        format, and tags them, all in one go.
      '';
    };
  }
