{ stdenv, fetchurl, alsaLib, libXv, libXi, libXrender, libXrandr, zlib, glib
, libXext, libX11, libXScrnSaver, libSM, qt4, libICE, freetype, fontconfig
, pulseaudio, usePulseAudio, lib }:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation rec {
  name = "skype-4.0.0.7";

  src = fetchurl {
    url = "http://download.skype.com/linux/${name}.tar.bz2";
    sha256 = "0mrswawqsv53mfghqlj1bzq0jfswha6b0c06px7snd85pd4gn5fn";
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
    mkdir -p $out/{opt/skype/,bin}
    cp -r * $out/opt/skype/

    fullPath=
    for i in $buildNativeInputs; do
      fullPath=$fullPath''${fullPath:+:}$i/lib
    done

    dynlinker="$(cat $NIX_GCC/nix-support/dynamic-linker)"
          
    cat > $out/bin/skype << EOF
    #!${stdenv.shell}
    export LD_LIBRARY_PATH=$fullPath:$LD_LIBRARY_PATH
    $dynlinker $out/opt/skype/skype --resources=$out/opt/skype "\$@"
    EOF

    chmod +x $out/bin/skype

    # Desktop icon for Skype
    patch skype.desktop << EOF
    5c5
    < Icon=skype.png
    ---
    > Icon=$out/opt/skype/icons/SkypeBlue_48x48.png
    EOF
    mkdir -p $out/share/applications
    mv skype.desktop $out/share/applications
  '';

  meta = {
      description = "A P2P-VoiceIP client";
      homepage = http://www.skype.com;
      license = "skype-eula";
  };
}
