{ stdenv, fetchzip, lib, wrapGAppsHook, alsa-lib, atk, cairo, gdk-pixbuf
, glib, gst_all_1,  gtk3, libSM, libX11, libpng12, pango, zlib }:

stdenv.mkDerivation rec {
  pname = "transcribe";
  version = "9.00";

  src = if stdenv.hostPlatform.system == "x86_64-linux" then
    fetchzip {
      url = "https://www.seventhstring.com/xscribe/downlo/xscsetup-9.00.0.tar.gz";
      sha256 = "0mgjx0hnps3jmc2d9hkskxbmwcqf7f9jx595j5sc501br1l84sdf";
    }
  else throw "Platform not supported";

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs = with gst_all_1; [ gst-plugins-base gst-plugins-good
    gst-plugins-bad gst-plugins-ugly ];

  dontPatchELF = true;

  libPath = with gst_all_1; lib.makeLibraryPath [
    stdenv.cc.cc glib gtk3 atk pango cairo gdk-pixbuf alsa-lib
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

  meta = with lib; {
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
  };
}
