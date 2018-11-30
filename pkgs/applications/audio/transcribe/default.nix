{ stdenv, fetchzip, wrapGAppsHook, alsaLib, atk, cairo, gdk_pixbuf
, glib, gst_all_1,  gtk3, libSM, libX11, libpng12, pango, zlib }:

stdenv.mkDerivation rec {
  name = "transcribe-${version}";
  version = "8.72";

  src = if stdenv.hostPlatform.system == "i686-linux" then
    fetchzip {
      url = "https://www.seventhstring.com/xscribe/downlinux32/xscsetup.tar.gz";
      sha256 = "1h5l7ry9c9awpxfnd29b0wm973ifrhj17xl5d2fdsclw2swsickb";
    }
  else if stdenv.hostPlatform.system == "x86_64-linux" then
    fetchzip {
      url = "https://www.seventhstring.com/xscribe/downlinux64/xsc64setup.tar.gz";
      sha256 = "1rpd3ppnx5i5yrnfbjrx7h7dk48kwl99i9lnpa75ap7nxvbiznm0";
    }
  else throw "Platform not supported";

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs = with gst_all_1; [ gst-plugins-base gst-plugins-good
    gst-plugins-bad gst-plugins-ugly ];

  dontPatchELF = true;

  libPath = with gst_all_1; stdenv.lib.makeLibraryPath [
    stdenv.cc.cc glib gtk3 atk pango cairo gdk_pixbuf alsaLib
    libX11 libSM libpng12 gstreamer gst-plugins-base zlib
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
    homepage = https://www.seventhstring.com/xscribe/;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ michalrus ];
  };
}
