{ stdenv, fetchzip, wrapGAppsHook, alsaLib, atk, cairo, gdk-pixbuf
, glib, gst_all_1,  gtk3, libSM, libX11, libXxf86vm, libpng12, pango, zlib }:

stdenv.mkDerivation rec {
  pname = "transcribe";
  version = "8.72";

  src = if stdenv.hostPlatform.system == "i686-linux" then
    fetchzip {
      url = "https://www.seventhstring.com/xscribe/xsc32setup.tar.gz";
      sha256 = "02z244mvwd8fdcdj62pzv34i2q7yr77z7jh9i5gn1fp3q6g9x2gc";
    }
  else if stdenv.hostPlatform.system == "x86_64-linux" then
    fetchzip {
      url = "https://www.seventhstring.com/xscribe/xsc64setup.tar.gz";
      sha256 = "01vysym52vbly7rss9c6i6wac4lbnfgz37xa5nz8ikqvwnmn34c3";
    }
  else throw "Platform not supported";

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs = with gst_all_1; [ gst-plugins-base gst-plugins-good
    gst-plugins-bad gst-plugins-ugly ];

  dontPatchELF = true;

  libPath = with gst_all_1; stdenv.lib.makeLibraryPath [
    stdenv.cc.cc glib gtk3 atk pango cairo gdk-pixbuf alsaLib
    libX11 libXxf86vm libSM libpng12 gstreamer gst-plugins-base zlib
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
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH_1_0"
      --prefix LD_LIBRARY_PATH : "${libPath}"
    )
  '';

  postFixup = ''
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
    homepage = "https://www.seventhstring.com/xscribe/";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ michalrus ];
    broken = false;
  };
}
