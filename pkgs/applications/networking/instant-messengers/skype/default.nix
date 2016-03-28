{ stdenv, fetchurl, libXv, libXi, libXrender, libXrandr, zlib, glib
, libXext, libX11, libXScrnSaver, libSM, qt4, libICE, freetype, fontconfig
, libpulseaudio, lib, ... }:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation rec {
  name = "skype-4.3.0.37";

  src = fetchurl {
    url = "http://download.skype.com/linux/${name}.tar.bz2";
    sha256 = "0bc9kck99rcsqzxzw3j6vnw5byvr8c9wixrx609zp255g0wxr6cc";
  };

  buildInputs = [
    stdenv.glibc
    stdenv.cc.cc
    libXv
    libXext
    libX11
    qt4
    libXScrnSaver
    libSM
    libICE
    libXi
    libXrender
    libXrandr
    libpulseaudio
    freetype
    fontconfig
    zlib
    glib
  ];

  phases = "unpackPhase installPhase";

  installPhase = ''
    mkdir -p $out/{libexec/skype/,bin}
    cp -r * $out/libexec/skype/

    fullPath=
    for i in $nativeBuildInputs; do
      fullPath=$fullPath''${fullPath:+:}$i/lib
    done

    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "$fullPath" $out/libexec/skype/skype

    cat > $out/bin/skype << EOF
    #!${stdenv.shell}
    export PULSE_LATENCY_MSEC=60  # workaround for pulseaudio glitches
    exec $out/libexec/skype/skype --resources=$out/libexec/skype "\$@"
    EOF

    chmod +x $out/bin/skype

    # Fixup desktop file
    substituteInPlace skype.desktop --replace \
      "Icon=skype.png" "Icon=$out/libexec/skype/icons/SkypeBlue_48x48.png"
    substituteInPlace skype.desktop --replace \
      "Terminal=0" "Terminal=false"
    mkdir -p $out/share/applications
    mv skype.desktop $out/share/applications
  '';

  meta = {
    description = "A proprietary voice-over-IP (VoIP) client";
    homepage = http://www.skype.com/;
    license = stdenv.lib.licenses.unfree;
    platforms = [ "i686-linux" ];
  };
}
