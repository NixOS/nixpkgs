{ stdenv, fetchurl, libcdio, cddiscid, wget, bash, vorbisTools, id3v2, lame
, makeWrapper }:

let version = "2.3.99.6";
in
  stdenv.mkDerivation {
    name = "abcde-${version}";
    src = fetchurl {
      url = "mirror://debian/pool/main/a/abcde/abcde_${version}.orig.tar.gz";
      sha256 = "1wl4ygj1cf1d6g05gwwygsd5g83l039fzi011r30ma5lnm763lyb";
    };

    # FIXME: This package does not support MP3 encoding (only Ogg),
    # nor `distmp3', `eject', etc.

    patches = [ ./install.patch ./which.patch ./cd-paranoia.patch ];

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

    buildInputs = [ makeWrapper ];

    postInstall = ''
      substituteInPlace "$out/bin/cddb-tool" \
         --replace '#!/bin/sh' '#!${bash}/bin/sh'
      substituteInPlace "$out/bin/abcde" \
         --replace '#!/bin/bash' '#!${bash}/bin/bash'

      wrapProgram "$out/bin/abcde" --prefix PATH ":" \
        "$out/bin:${libcdio}/bin:${cddiscid}/bin:${wget}/bin:${vorbisTools}/bin:${id3v2}/bin:${lame}/bin"

      wrapProgram "$out/bin/cddb-tool" --prefix PATH ":" \
        "${wget}/bin"
    '';

    meta = {
      homepage = http://www.hispalinux.es/~data/abcde.php;
      licence = "GPLv2+";
      description = "A Better CD Encoder (ABCDE)";

      longDescription = ''
        abcde is a front-end command-line utility (actually, a shell
        script) that grabs tracks off a CD, encodes them to
        Ogg/Vorbis, MP3, FLAC, Ogg/Speex and/or MPP/MP+ (Musepack)
        format, and tags them, all in one go.
      '';
    };
  }
