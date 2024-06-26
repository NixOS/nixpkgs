{
  stdenv,
  fetchzip,
  lib,
  wrapGAppsHook3,
  xdg-utils,
  which,
  alsa-lib,
  atk,
  cairo,
  fontconfig,
  gdk-pixbuf,
  glib,
  gst_all_1,
  gtk3,
  libSM,
  libX11,
  libXtst,
  libpng12,
  pango,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "transcribe";
  version = "9.40.0";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchzip {
        url = "https://www.seventhstring.com/xscribe/downlo/xscsetup-${version}.tar.gz";
        sha256 = "sha256-GHTr1rk7Kh5M0UYnryUlCk/G6pW3p80GJ6Ai0zXdfNs=";
      }
    else
      throw "Platform not supported";

  nativeBuildInputs = [
    which
    xdg-utils
    wrapGAppsHook3
  ];

  buildInputs = with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ];

  dontPatchELF = true;

  libPath =
    with gst_all_1;
    lib.makeLibraryPath [
      stdenv.cc.cc
      glib
      gtk3
      atk
      fontconfig
      pango
      cairo
      gdk-pixbuf
      alsa-lib
      libX11
      libXtst
      libSM
      libpng12
      gstreamer
      gst-plugins-base
      zlib
    ];

  installPhase = ''
    mkdir -p $out/bin $out/libexec $out/share/doc
    cp transcribe $out/libexec
    cp xschelp.htb readme_gtk.html $out/share/doc
    ln -s $out/share/doc/xschelp.htb $out/libexec
    # The script normally installs to the home dir
    sed -i -E 's!BIN_DST=.*!BIN_DST=$out!' install-linux.sh
    sed -i -e 's!Exec=''${BIN_DST}/transcribe/transcribe!Exec=transcribe!' install-linux.sh
    sed -i -e 's!''${BIN_DST}/transcribe!''${BIN_DST}/libexec!' install-linux.sh
    rm -f xschelp.htb readme_gtk.html *.so
    XDG_DATA_HOME=$out/share bash install-linux.sh -i
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
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ iwanb ];
    platforms = platforms.linux;
    mainProgram = "transcribe";
  };
}
