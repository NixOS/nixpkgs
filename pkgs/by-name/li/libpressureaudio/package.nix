{
  stdenv,
  apulse,
  libpulseaudio,
  pkg-config,
  intltool,
}:

stdenv.mkDerivation {
  pname = "libpressureaudio";
  version = apulse.version;

  src = libpulseaudio.src;

  nativeBuildInputs = [
    pkg-config
    intltool
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    echo "Copying libraries from apulse."
    mkdir -p $out/lib
    ls ${apulse}/lib/apulse $out/lib
    cp -a ${apulse}/lib/apulse/* $out/lib/

    echo "Copying headers from pulseaudio."
    mkdir -p $out/include/pulse
    cp -a src/pulse/*.h $out/include/pulse

    echo "Generating custom pkgconfig definitions."
    mkdir -p $out/lib/pkgconfig
    for a in libpulse.pc libpulse-simple.pc libpulse-mainloop-glib.pc ; do
        cat > $out/lib/pkgconfig/$a << EOF
    prefix=$out
    libdir=$out/lib
    includedir=$out/include

    EOF
    done

    cat >> $out/lib/pkgconfig/libpulse.pc << EOF
    Name: libpulse
    Description: PulseAudio Client Interface
    Version: ${libpulseaudio.version}-rebootstrapped
    Libs: -L$out/lib -lpulse
    Cflags: -I$out/include -D_REENTRANT
    EOF

    cat >> $out/lib/pkgconfig/libpulse-simple.pc << EOF
    Name: libpulse-simple
    Description: PulseAudio Simplified Synchronous Client Interface
    Version: ${libpulseaudio.version}-rebootstrapped
    Libs: -L$out/lib -lpulse-simple
    Cflags: -I$out/include -D_REENTRANT
    Requires: libpulse
    EOF

    cat >> $out/lib/pkgconfig/libpulse-mainloop-glib.pc << EOF
    Name: libpulse-mainloop-glib
    Description: PulseAudio GLib 2.0 Main Loop Wrapper
    Version: ${libpulseaudio.version}-rebootstrapped
    Libs: -L$out/lib -lpulse-mainloop-glib
    Cflags: -I$out/include -D_REENTRANT
    Requires: libpulse glib-2.0
    EOF

    runHook postInstall
  '';

  meta = apulse.meta // {
    description = "Libpulse without any sound daemons over pure ALSA";
    longDescription = ''
      apulse (${apulse.meta.homepage}) implements most of libpulse
      API over pure ALSA in 5% LOC of the original PulseAudio.

      But apulse is made to be used as a wrapper that substitutes its
      replacement libs into LD_LIBRARY_PATH. The problem with that is
      that you still have to link against the original libpulse.

      pressureaudio (http://git.r-36.net/pressureaudio/) wraps apulse
      with everything you need to replace libpulse completely.

      This derivation is a reimplementation of pressureaudio in pure
      nix.

      You can simply override libpulse with this and most
      packages would just work.
    '';
  };
}
