{stdenv, fetchurl, alsaLib, libXv, libXi, libXrender, libXrandr, zlib, glib
, libXext, libX11, libXScrnSaver, libSM, qt, libICE, freetype, fontconfig}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation rec {
  name = "skype-2.1.0.81";

  src = fetchurl {
    url = "http://download.skype.com/linux/${name}.tar.bz2";
    sha256 = "1x18m4900c0ssaq95wv8mhhgwvw9fh66dszx7zq24zgvb2v1h4jz";
  };

  buildInputs = [
    alsaLib 
    stdenv.glibc 
    stdenv.gcc.gcc
    libXv
    libXext 
    libX11 
    qt
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
  '';

  meta = {
      description = "A P2P-VoiceIP client";
      homepage = http://www.skype.com;
      license = "skype-eula";
  };
}
