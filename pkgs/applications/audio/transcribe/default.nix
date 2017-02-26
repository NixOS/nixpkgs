{ stdenv, fetchzip, lib, makeWrapper, alsaLib, atk, cairo, gdk_pixbuf
, glib, gst-ffmpeg, gst-plugins-bad, gst_plugins_base
, gst-plugins-good, gst-plugins-ugly, gstreamer, gtk2, libSM, libX11
, libpng12, pango, zlib }:

stdenv.mkDerivation rec {
  name = "transcribe-${version}";
  version = "8.40";

  src = if stdenv.system == "i686-linux" then
    fetchzip {
      url = "https://www.seventhstring.com/xscribe/downlinux32_old/xscsetup.tar.gz";
      sha256 = "1ngidmj9zz8bmv754s5xfsjv7v6xr03vck4kigzq4bpc9b1fdhjq";
    }
  else if stdenv.system == "x86_64-linux" then
    fetchzip {
      url = "https://www.seventhstring.com/xscribe/downlinux64_old/xsc64setup.tar.gz";
      sha256 = "0svzi8svj6zn06gj0hr8mpnhq4416dvb4g5al0gpb1g3paywdaf9";
    }
  else throw "Platform not supported";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ gst_plugins_base gst-plugins-good
    gst-plugins-bad gst-plugins-ugly gst-ffmpeg ];

  dontPatchELF = true;

  libPath = lib.makeLibraryPath [
    stdenv.cc.cc glib gtk2 atk pango cairo gdk_pixbuf alsaLib
    libX11 libSM libpng12 gstreamer gst_plugins_base zlib
  ];

  installPhase = ''
    mkdir -p $out/bin $out/libexec $out/share/doc
    cp transcribe $out/libexec
    cp xschelp.htb readme_gtk.html $out/share/doc
    cp -r gtkicons $out/share/icons

    ln -s $out/share/doc/xschelp.htb $out/libexec

    patchelf \
      --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      $out/libexec/transcribe

    wrapProgram $out/libexec/transcribe \
      --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH" \
      --prefix LD_LIBRARY_PATH : "${libPath}"

    ln -s $out/libexec/transcribe $out/bin/
    '';

  meta = with stdenv.lib; {
    description = "Software to help transcribe recorded music";
    longDescription = ''
      The Transcribe! application is an assistant for people who want
      to work out a piece of music from a recording, in order to write
      it out, or play it themselves, or both. It doesn't do the
      transcribing for you, but it is essentially a specialised player
      program which is optimised for the purpose of transcription. It
      has many transcription-specific features not found on
      conventional music players.
    '';
    homepage = https://www.seventhstring.com/xscribe/;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ michalrus ];
  };
}
