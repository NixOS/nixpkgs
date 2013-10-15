{ stdenv, fetchurl, alsaLib, libXv, libXi, libXrender, libXrandr, zlib, glib
, libXext, libX11, libXScrnSaver, libSM, qt4, libICE, freetype, fontconfig
, pulseaudio, usePulseAudio, lib }:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation rec {
  name = "skype-4.2.0.11";

  src = fetchurl {
    url = "http://download.skype.com/linux/${name}.tar.bz2";
    sha256 = "0kh66p50m3x4ql6j8ciz73c30npcizd00ya9qrhid711rar0mlw7";
  };

  buildInputs =
    lib.optional usePulseAudio pulseaudio ++ [
    alsaLib
    stdenv.glibc
    stdenv.gcc.gcc
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

    dynlinker="$(cat $NIX_GCC/nix-support/dynamic-linker)"

    cat > $out/bin/skype << EOF
    #!${stdenv.shell}
    export PULSE_LATENCY_MSEC=60  # workaround for pulseaudio glitches
    export LD_LIBRARY_PATH=$fullPath:$LD_LIBRARY_PATH
    $dynlinker $out/libexec/skype/skype --resources=$out/libexec/skype "\$@"
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
    license = "unfree";
  };
}
