{ stdenv, fetchurl, alsaLib, libXv, libXi, libXrender, libXrandr, zlib, glib
, libXext, libX11, libXScrnSaver, libSM, qt4, libICE, freetype, fontconfig
, pulseaudio }:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation rec {
  name = "skype-2.2.0.35";

  src = fetchurl {
    url = "http://download.skype.com/linux/${name}.tar.bz2";
    sha256 = "157ba3ci12bq0nv2m8wlsab45ib5sccqagyna8nixnhqw9q72sxm";
  };

  buildInputs = [
    alsaLib
    pulseaudio
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
    ensureDir $out/{opt/skype/,bin}
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
    ensureDir $out/share/applications
    mv skype.desktop $out/share/applications
  '';

  meta = {
      description = "A P2P-VoiceIP client";
      homepage = http://www.skype.com;
      license = "skype-eula";
  };
}
